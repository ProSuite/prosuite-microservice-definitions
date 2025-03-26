# ProSuite QA Microservice Definitions for external tests

[ProSuite QA](https://dirageosystems.ch/prosuite) provides quality verification functionality for geographic data implemented in a microservice architecture. 
This package contains the .NET assemblies of the [gRPC](https://github.com/grpc) microservice APIs for the external or third-party QA test implementations and its client used in different repositories.

In case the other ProSuite Microservice Definitions are used in the same application, make sure to use corresponding versions, as they all have a reference to ProSuite.Microservices.Definitions.Shared containing shared message definitions.

## Versioning

We plan to use [SemVer](http://semver.org/) for versioning once version 1.0 is released. For the moment we do not guarantee any kind of compatibility, so make sure the client and server implementations use the same package version.

## Authors

The ProSuite Authors.

## License

This project is licensed under the MIT License.
