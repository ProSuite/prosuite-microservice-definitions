# Builds the QA service definitions to the output directory
# The relevant output is
# - ProSuite.Microservices.Definitions.Shared.*
# - ProSuite.Microservices.Definitions.QA.*
# These python files can be checked into the consuming repo's lib folder.

cd $PSScriptRoot

mode con:cols=200 lines=15000

python -m grpc.tools.protoc --proto_path=../src/protos --python_out=output --grpc_python_out=output quality_verification_service.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=output shared_types.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=output shared_qa.proto
python -m grpc.tools.protoc --proto_path=../src/protos --python_out=output --grpc_python_out=output quality_test.proto

pause
