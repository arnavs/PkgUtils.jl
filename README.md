# PkgUtils

[![Build Status](https://travis-ci.org/arnavs/PkgUtils.jl.svg?branch=master)](https://travis-ci.org/arnavs/PkgUtils.jl)

Some small utilities to help Julia package users and authors. This package is basically a smorgasbord of code that others have submitted and I could never have written myself. https://github.com/ianshmean and https://github.com/harryscholes also provided lots of emotional support. 

## Environments

* `manifest!"..."` creates and activates a throwaway environment based on the contents of a `Manifest.toml`.
* `project!"..."` creates and activates a throwaway environment based on the contents of a `Project.toml`.

Thanks to https://github.com/christopher-DG and https://github.com/oxinabox for this feature. 

## Dependencies and Dependents

* `get_dependents("MyPackage", n = 1)` returns n-th order dependents of `MyPackage` (in the `General` registry.)

* `get_dependencies("SomePackage", n = 1)` returns n-th order dependencies of `SomePackage`.

* `get_latest_version("SomePackage")` will get the latest version of that package. 

Thanks to https://github.com/sbromberger for most of this code. 

## Snapshot 

* `snapshot!()` will save a copy of your current project and manifest file in the relevant `environments/` folder.

* `undo!()` will revert the current project and manifest to the most recent snapshot.  
