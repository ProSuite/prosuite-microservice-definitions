# Builds the QA service definitions to the output directory
# The relevant output is
# - ProSuite.Microservices.Definitions.Shared.*
# - ProSuite.Microservices.Definitions.Geometry.*
# These assemblies can be checked into the consuming repo's lib folder.

cd $PSScriptRoot

mode con:cols=200 lines=15000

dotnet build ..\src\ProSuite.Microservices.Definitions.Shared\ProSuite.Microservices.Definitions.Shared.csproj -property:Configuration=Release -o .\output
dotnet build ..\src\ProSuite.Microservices.Definitions.Geometry\ProSuite.Microservices.Definitions.Geometry.csproj -property:Configuration=Release -o .\output

pause