# Builds the QA service definitions to the output directory
# The relevant output is
# - ProSuite.Microservices.Definitions.Shared.*
# - ProSuite.Microservices.Definitions.QA.*
# These assemblies can be checked into the consuming repo's lib folder.

cd $PSScriptRoot

mode con:cols=200 lines=15000

dotnet build ..\src\ProSuite.Microservices.Definitions.Shared\ProSuite.Microservices.Definitions.Shared.csproj -property:Configuration=Release -o .\output
dotnet build ..\src\ProSuite.Microservices.Definitions.QA\ProSuite.Microservices.Definitions.QA.csproj -property:Configuration=Release -o .\output
dotnet build ..\src\ProSuite.Microservices.Definitions.QA.Test\ProSuite.Microservices.Definitions.QA.Test.csproj -property:Configuration=Release -o .\output

pause