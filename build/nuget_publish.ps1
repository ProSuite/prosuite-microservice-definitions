
# NOTE: In order to publish, the API key stored in the keypass must be set first, using
# nuget setApiKey <apikey>


# Specify the path to your XML file
$buildPropsFile = "..\src\Directory.Build.props"

# Load the XML content
[xml]$xmlContent = Get-Content -Path $buildPropsFile

# Extract the Version element value
$version = $xmlContent.Project.PropertyGroup.Version

# Output the version
Write-Output "Determined Package Version: $version"

$packageNameQA = ".\output\nuget\DiraGeoSystems.ProSuite.Microservices.QA.$version.nupkg"

Write-Output "Publishing $packageNameQA"

nuget push $packageNameQA -Source https://api.nuget.org/v3/index.json



$packageNameGeometry = ".\output\nuget\DiraGeoSystems.ProSuite.Microservices.Geometry.$version.nupkg"

Write-Output "Publishing $packageNameGeometry"

nuget push $packageNameGeometry -Source https://api.nuget.org/v3/index.json


pause

