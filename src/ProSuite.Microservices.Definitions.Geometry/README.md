# ProSuite Geometry Microservice Definitions

[ProSuite Edit Tools](https://dirageosystems.ch/prosuite) provides high-productivity geodata editing functionality in ArcGIS implemented with a microservice architecture. 
This package contains the .NET assemblies of the [gRPC](https://github.com/grpc) microservice APIs for the geometry processing servers and clients used in different repositories.

In case the other ProSuite Microservice Definitions are used in the same application, make sure to use corresponding versions, as they all have a reference to ProSuite.Microservices.Definitions.Shared containing shared message definitions.

## Versioning

We plan to use [SemVer](http://semver.org/) for versioning once version 1.0 is released. For the moment we do not guarantee any kind of compatibility, so make sure the client and server implementations use the same package version.

## Authors

The ProSuite Authors.

## License

This project is licensed under the MIT License.
