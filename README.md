# prosuite-microservice-definitions
Defines ProSuite's [gRPC](https://github.com/grpc) microservice APIs for servers and clients implemented in different repositories.

The ProSuite microservices are designed to make existing (ArcObjects-based) functionality, such as quality verification or feature manipulation, available to various clients (ArcMap, ArcGIS Pro, command line applications, etc.).

The microservice APIs are defined by the gRPC proto files in this repository. Building the solution will produce the assemblies / Nuget packages that can be consumed by client or server implementers.

## Building the C# assemblies
Use the relevant script in the build directory to build the assemblies or the nuget packages.

## Versioning

We plan to use [SemVer](http://semver.org/) for versioning once version 1.0 is released. For the moment we do not guarantee any kind of compatibility.
For the versions available, see the [tags on this repository](https://github.com/ProSuite/prosuite-microservice-definitions/tags).

## Authors

The ProSuite Authors.

## Contributing

* Stick to the protocol-buffers' [style guide](https://developers.google.com/protocol-buffers/docs/style) as long as it makes sense.
* The actual proto files reside in the src\proto folder. In order to compile them into their respective assemblies without name conflicts in client code we must not compile the referenced types into the same assembly. However, protoc requires the referenced proto file to reside next to the proto file that uses the referenced types. In order to avoid copying the referenced files (e.g. core_types.proto) around:
  * Keep all proto files in a central location (src\protos\*.proto)
  * In the csproj:
    * Add the file(s) to be compiled to C# types using <Protobuf Include=... Link(!)> as shown in the google examples
    * Add the referenced proto file(s) that MUST NOT be compiled to avoid name conflicts using <Content Include=... Link=> or even <Item Include= to hide it in Visual Studio
see: [Protocol Buffers/gRPC Integration Into .NET Build](https://github.com/grpc/grpc/blob/master/src/csharp/BUILD-INTEGRATION.md) for details.
* Document messages and field names in proto files to illustrate their purpose. We might consider a documentation generation tool in the future.
* Respect intellectual property rights and copyright laws. Only commit content consistent with our license.

## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details
