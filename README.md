# PkgUtils

Some small utilities to help Julia package authors. Thanks to @sbromberger and @ianshmean and @harryscholes and others for providing code, inspiration, etc. 

## Dependencies and Dependents

* `get_dependents("MyPackage", n = 1)` returns n-th order dependents of `MyPackage` (in the `General` registry.)

* `get_dependencies("SomePackage", n = 1)` returns n-th order dependencies of `SomePackage`.

* `trim_dependencies("MyPackage")` returns a list of named dependencies the package doesn't actually use. 

:warning: The thing above works by using `SnoopCompile.jl` on your tests. So it's only as good as the test coverage. 
