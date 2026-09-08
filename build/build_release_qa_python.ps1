<#
.SYNOPSIS
    Generates the Python gRPC stubs for the ProSuite-API package (python package 'prosuite')
    from the .proto files in ..\src\protos.

.DESCRIPTION
    The stubs are generated into .\output\python. From there they are copied (manually, or with
    -Copy) into the ProSuite-API package of the consuming repository:

        <Swisstopo.GoTop>\ProSuite.Shared\py\ProSuite-Meta\py-packages\ProSuite-API\src\prosuite\generated

    Note on versions:
    The structure of the generated files depends on the versions of 'grpcio-tools' and 'protobuf'
    that protoc runs with (e.g. protobuf 4.x emits a different import pattern than protobuf 6.x).
    To keep the generated code consistent with what the 'prosuite' package actually pins, protoc is
    run through 'uv run --project <ProSuite-API>' against the ProSuite-API project in the
    Dira.ProSuiteSolution repository, which owns those pins. That project's locked environment
    provides the 'grpcio-tools' dev dependency, so no global Python install is involved.

    If that project cannot be found, the script falls back to an ephemeral uv environment
    ('uv run --no-project --with grpcio-tools'), which resolves to the *latest* grpcio-tools and
    may therefore produce a different code structure.

.PARAMETER PythonProject
    Path to the ProSuite-API uv project whose locked environment provides grpcio-tools and
    determines the generated code structure. Defaults to the Dira.ProSuiteSolution checkout next to
    this repository. This project is only used to run protoc - nothing is written into it.

.PARAMETER Destination
    The 'generated' package directory the stubs are copied into by -Copy. Defaults to the
    ProSuite-API package in the Swisstopo.GoTop checkout next to this repository.

.PARAMETER Copy
    After a successful generation, copy the generated files into $Destination. Existing files are
    overwritten; __init__.py (the sys.path shim, which protoc does not emit) is left untouched.

.EXAMPLE
    # Generate only, then copy by hand:
    .\build_release_qa_python.ps1

.EXAMPLE
    # Generate and copy into the ProSuite-API package:
    .\build_release_qa_python.ps1 -Copy

.EXAMPLE
    # Generate and copy into the Dira.ProSuiteSolution working copy instead:
    .\build_release_qa_python.ps1 -Copy -Destination "C:\git\Dira.ProSuiteSolution\ProSuite.Shared\py\ProSuite-Meta\py-packages\ProSuite-API\src\prosuite\generated"
#>
param(
    [string]$PythonProject = (Join-Path $PSScriptRoot "../../Dira.ProSuiteSolution/ProSuite.Shared/py/ProSuite-Meta/py-packages/ProSuite-API"),
    [string]$Destination = (Join-Path $PSScriptRoot "../../Swisstopo.GoTop/ProSuite.Shared/py/ProSuite-Meta/py-packages/ProSuite-API/src/prosuite/generated"),
    [switch]$Copy
)

Set-Location $PSScriptRoot

$ErrorActionPreference = "Stop"

$ProtoDir  = Join-Path $PSScriptRoot "../src/protos"
$OutputDir = Join-Path $PSScriptRoot "output/python"

# Services: message classes, type stubs and gRPC client/servicer code.
$ServiceProtos = @(
    "quality_verification_service.proto",
    "quality_verification_ddx.proto",
    "quality_test.proto"
)

# Shared definitions: message classes and type stubs only (they declare no services).
$MessageProtos = @(
    "shared_qa.proto",
    "shared_gdb.proto",
    "shared_ddx.proto",
    "shared_commons.proto"
)

function Write-Step($message) {
    Write-Host ""
    Write-Host $message -ForegroundColor Cyan
}

# --- Preconditions -------------------------------------------------------------------------

if (-not (Get-Command uv -ErrorAction SilentlyContinue)) {
    Write-Host "uv was not found on the PATH." -ForegroundColor Red
    Write-Host "Install it from https://docs.astral.sh/uv/ (e.g. 'winget install astral-sh.uv') and re-run." -ForegroundColor Red
    pause
    exit 1
}

if (-not (Test-Path $ProtoDir)) {
    Write-Host "Proto directory not found: $ProtoDir" -ForegroundColor Red
    pause
    exit 1
}

$ProtoDir = (Resolve-Path $ProtoDir).Path

$missing = $ServiceProtos + $MessageProtos | Where-Object { -not (Test-Path (Join-Path $ProtoDir $_)) }
if ($missing) {
    Write-Host "Missing proto file(s) in ${ProtoDir}:" -ForegroundColor Red
    $missing | ForEach-Object { Write-Host "  $_" -ForegroundColor Red }
    pause
    exit 1
}

# --- Determine how protoc is run -----------------------------------------------------------

$resolvedProject = Resolve-Path $PythonProject -ErrorAction SilentlyContinue

if ($resolvedProject) {
    $PythonProject = $resolvedProject.Path
    $UvArgs = @("run", "--project", $PythonProject)
    Write-Step "Using the ProSuite-API environment for protoc (grpcio-tools / protobuf versions):"
    Write-Host "  $PythonProject"
}
else {
    $UvArgs = @("run", "--no-project", "--with", "grpcio-tools")
    Write-Step "ProSuite-API project not found at:"
    Write-Host "  $PythonProject" -ForegroundColor Yellow
    Write-Host "Falling back to an ephemeral environment with the latest grpcio-tools." -ForegroundColor Yellow
    Write-Host "The generated code structure may differ from what the package pins." -ForegroundColor Yellow
}

# --- Generate ------------------------------------------------------------------------------

Write-Step "Preparing output directory..."

if (Test-Path $OutputDir) {
    Remove-Item $OutputDir -Recurse -Force
}
New-Item -Path $OutputDir -ItemType Directory -Force | Out-Null

$OutputDir = (Resolve-Path $OutputDir).Path
Write-Host "  $OutputDir"

Write-Step "Generating Python gRPC stubs from $ProtoDir ..."

$failed = @()

function Invoke-Protoc {
    param(
        [string]$Proto,
        [switch]$WithGrpc
    )

    $protocArgs = @(
        "python", "-m", "grpc_tools.protoc",
        "--proto_path=$ProtoDir",
        "--python_out=$OutputDir",
        "--pyi_out=$OutputDir"
    )

    if ($WithGrpc) {
        $protocArgs += "--grpc_python_out=$OutputDir"
    }

    $protocArgs += $Proto

    & uv @UvArgs @protocArgs

    if ($LASTEXITCODE -ne 0) {
        Write-Host "  [FAILED]  $Proto (protoc exit code $LASTEXITCODE)" -ForegroundColor Red
        $script:failed += $Proto
    }
    else {
        $suffix = if ($WithGrpc) { "(messages + stubs + grpc)" } else { "(messages + stubs)" }
        Write-Host "  [OK]      $Proto $suffix" -ForegroundColor Green
    }
}

foreach ($proto in $ServiceProtos) { Invoke-Protoc -Proto $proto -WithGrpc }
foreach ($proto in $MessageProtos) { Invoke-Protoc -Proto $proto }

if ($failed.Count -gt 0) {
    Write-Step "Generation failed for $($failed.Count) of $($ServiceProtos.Count + $MessageProtos.Count) proto file(s)."
    pause
    exit 1
}

$generated = Get-ChildItem -Path $OutputDir -File
Write-Step "Generated $($generated.Count) file(s) in $OutputDir"
Write-Host "Successfully generated the ProSuite-API python grpc stubs" -ForegroundColor Green

# --- Copy (optional) -----------------------------------------------------------------------

$resolvedDestination = Resolve-Path $Destination -ErrorAction SilentlyContinue
if ($resolvedDestination) {
    $Destination = $resolvedDestination.Path
}

if (-not $Copy) {
    Write-Step "Next step: copy the generated files into the ProSuite-API package."
    Write-Host "  Copy-Item -Path `"$OutputDir\*`" -Destination `"$Destination`" -Force"
    Write-Host ""
    Write-Host "Or re-run this script with -Copy to do it automatically." -ForegroundColor DarkGray
    Write-Host "Note: __init__.py in the target holds the sys.path shim and is not generated by protoc - do not delete it." -ForegroundColor DarkGray
    pause
    exit 0
}

Write-Step "Copying the generated files to:"
Write-Host "  $Destination"

try {
    if (-not (Test-Path $Destination)) {
        New-Item -Path $Destination -ItemType Directory -Force | Out-Null
    }

    # Overwrite the generated files only; __init__.py (the sys.path shim) is not emitted by protoc
    # and therefore stays in place.
    Copy-Item -Path (Join-Path $OutputDir "*") -Destination $Destination -Force -ErrorAction Stop

    Write-Host "Successfully copied $($generated.Count) file(s)" -ForegroundColor Green
}
catch {
    Write-Host "Copying python files failed: $($_.Exception.Message)" -ForegroundColor Red
    pause
    exit 1
}

pause
