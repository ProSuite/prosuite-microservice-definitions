# Builds the QA service definitions to the output directory
# The relevant output is
# - ProSuite.Microservices.Definitions.Shared.*
# - ProSuite.Microservices.Definitions.QA.*
# These python files can be checked into the consuming repo's lib folder.

# Note:
# The structure of the generated files depends on the active Python
# environment at build time. The installed versions of 'grpcio-tools' and
# 'protobuf' determine which code pattern is produced.
# (e.g., building with protobuf 4.x produces files that import 'runtime_version',
# while protobuf 6.x creates a different import structure.)
# When the base environment is active during the build, the Protobuf files
# are generated using the structure of the newest available protobuf/grpc
# versions.

Set-Location $PSScriptRoot

$OutputDir = "output/python" 
Remove-Item $OutputDir -Recurse
mkdir $OutputDir

python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir --grpc_python_out=$OutputDir quality_verification_service.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir --grpc_python_out=$OutputDir quality_verification_ddx.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir shared_qa.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir shared_gdb.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir shared_ddx.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=$OutputDir --pyi_out=$OutputDir --grpc_python_out=$OutputDir quality_test.proto

Write-Host "Created python output in ${OutputDir}"

Pause
