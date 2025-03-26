# Builds the QA service definitions and packs them into a nupkg
# The relevant output is
# - ProSuite.Microservices.Definitions.Shared.*.nupkg
# - ProSuite.Microservices.Definitions.QA.*.nupkg

# Note: The very large native libraries are excluded. They will be provided by the gRPC nuget package.

#
# Make sure nuget.exe is in the PATH
#

cd $PSScriptRoot

mode con:cols=200 lines=15000

# QA:
dotnet build ..\src\ProSuite.Microservices.Definitions.QA\ProSuite.Microservices.Definitions.QA.csproj -property:Configuration=Release

# exclude the native binaries, otherwise the package would become huge (https://stackoverflow.com/questions/41941588/binaries-are-added-to-project-when-nuget-package-has-grpc-core-as-a-dependency)
nuget pack ..\src\ProSuite.Microservices.Definitions.QA\ProSuite.Microservices.Definitions.QA.csproj -Exclude '**\*.x86.*;**\*.x64.*' -OutputDirectory .\output\nuget -Properties Configuration=Release


# QA.Test:
dotnet build ..\src\ProSuite.Microservices.Definitions.QA.Test\ProSuite.Microservices.Definitions.QA.Test.csproj -property:Configuration=Release

# exclude the native binaries, otherwise the package would become huge (https://stackoverflow.com/questions/41941588/binaries-are-added-to-project-when-nuget-package-has-grpc-core-as-a-dependency)
nuget pack ..\src\ProSuite.Microservices.Definitions.QA.Test\ProSuite.Microservices.Definitions.QA.Test.csproj -Exclude '**\*.x86.*;**\*.x64.*' -OutputDirectory .\output\nuget -Properties Configuration=Release

# Geometry:
dotnet build ..\src\ProSuite.Microservices.Definitions.Geometry\ProSuite.Microservices.Definitions.Geometry.csproj -property:Configuration=Release
nuget pack ..\src\ProSuite.Microservices.Definitions.Geometry\ProSuite.Microservices.Definitions.Geometry.csproj -Exclude '**\*.x86.*;**\*.x64.*' -OutputDirectory .\output\nuget -Properties Configuration=Release


pause