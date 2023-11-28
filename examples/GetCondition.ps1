#
# Gets a quality condition from the DDX.
#
# Make sure grpcurl.exe (https://github.com/fullstorydev/grpcurl) is in the path
#
# This example works when there is a service running that listens at the specified address.
# 
# Usage:
# GetCondition.ps1 HOSTNAME:Port QualityConditionName {DDX envrionment name} {PEM file with certificate authority}
#
# Example (insecure):
# GetCondition.ps1 localhost:5151 "OSM_Gewaesser_L_KeineÄhnlicheVerläufe"
#
# Example (using TLS):
# GetCondition.ps1 MY_MACHINE.domain.com:5151 "OSM_Gewaesser_L_KeineÄhnlicheVerläufe" "Development" "C:\Temp\root_ca.cer"

param (
	$Address = $(throw "Address in the form localhost:5151 is required."),
	$QualityConditionName = $(throw "QualityConditionName required."),
    $DdxEnvironment,
	$cacert_file
)

Write-host "Getting quality condition $QualityConditionName at address $Address..."

$scriptpath = $MyInvocation.MyCommand.Path
$dir = Split-Path $scriptpath
cd $dir
Write-host "Changed directory to $dir"

if ($cacert_file) 
{
	Write-host "TLS: Using specified PEM file: " $cacert_file
	$tlsArg="-cacert"
}
else 
{
	Write-host "Using insecure credentials (no TLS)"
	$tlsArg="-plaintext"
}

$EnvironmentNameJson = ""
if ($DdxEnvironment)
{
    $EnvironmentNameJson = ', \"environment\": \"' + $DdxEnvironment + '\"'
}

$QualityConditionNameJson = '{\"condition_name\": \"' + $QualityConditionName + '\"' + $EnvironmentNameJson + '}'
Write-host "grpcurl request: $QualityConditionNameJson"
Write-host "grpcurl response:"

$watch = [Diagnostics.Stopwatch]::StartNew()

grpcurl.exe -d $QualityConditionNameJson $tlsArg $cacert_file -import-path ..\src\protos -proto "quality_verification_ddx.proto" $Address ProSuite.Microservices.Definitions.QA.QualityVerificationDdxGrpc/GetQualityCondition

$watch.Stop()
Write-host "Total Milliseconds:" $watch.Elapsed.TotalMilliseconds

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
