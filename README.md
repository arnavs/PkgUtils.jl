# PkgUtils

Some small utilities to help Julia package authors. Thanks to @sbromberger and @ianshmean, among others.

## Dependencies and Dependents

* `get_dependents("MyPackage", n = 1)` returns n-th order dependents of `MyPackage` (in the `General` registry.)

* `get_dependencies("SomePackage")` returns direct dependencies of `SomePackage`.

