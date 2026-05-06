# Builds the QA service definitions and packs them into a nupkg
# The relevant output is
# - ProSuite.Microservices.Definitions.Shared.*.nupkg
# - ProSuite.Microservices.Definitions.QA.*.nupkg

cd $PSScriptRoot

mode con:cols=200 lines=15000

# QA:
Write-Host "Building and packing DiraGeoSystems.ProSuite.Microservices.QA..."
dotnet build ..\src\ProSuite.Microservices.Definitions.QA\ProSuite.Microservices.Definitions.QA.csproj -property:Configuration=Release
dotnet pack ..\src\ProSuite.Microservices.Definitions.QA\ProSuite.Microservices.Definitions.QA.csproj -o .\output\nuget -c Release
Write-Host "-------------------"
Write-Host

# QA.Test:
Write-Host "Building and packing DiraGeoSystems.ProSuite.Microservices.QA.Test..."
dotnet build ..\src\ProSuite.Microservices.Definitions.QA.Test\ProSuite.Microservices.Definitions.QA.Test.csproj -property:Configuration=Release
dotnet pack ..\src\ProSuite.Microservices.Definitions.QA.Test\ProSuite.Microservices.Definitions.QA.Test.csproj -o .\output\nuget -c Release
Write-Host "-------------------"
Write-Host

# Geometry:
Write-Host "Building and packing DiraGeoSystems.ProSuite.Microservices.Geometry..."
dotnet build ..\src\ProSuite.Microservices.Definitions.Geometry\ProSuite.Microservices.Definitions.Geometry.csproj -property:Configuration=Release
dotnet pack ..\src\ProSuite.Microservices.Definitions.Geometry\ProSuite.Microservices.Definitions.Geometry.csproj -o .\output\nuget -c Release
Write-Host "-------------------"
Write-Host

pause