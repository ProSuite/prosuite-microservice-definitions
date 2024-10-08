# Builds the QA service definitions to the output directory
# The relevant output is
# - ProSuite.Microservices.Definitions.Shared.*
# - ProSuite.Microservices.Definitions.QA.*
# These python files can be checked into the consuming repo's lib folder.

Set-Location $PSScriptRoot

$OutputDir = "output/python" 
Remove-Item $OutputDir -Recurse
mkdir $OutputDir

python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir --grpc_python_out=$OutputDir quality_verification_service.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir --grpc_python_out=$OutputDir quality_verification_ddx.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir shared_types.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir shared_qa.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir --grpc_python_out=$OutputDir quality_test.proto

Write-Host "Created python output in ${OutputDir}"

Pause
