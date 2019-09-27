# PkgUtils

[![Build Status](https://travis-ci.org/arnavs/PkgUtils.jl.svg?branch=master)](https://travis-ci.org/arnavs/PkgUtils.jl)

Some small utilities to help Julia package users and authors. Thanks to @sbromberger and @ianshmean and @harryscholes and others for providing code, inspiration, etc. 

## Snapshot 

* `snapshot!()` will save a copy of your current project and manifest file in the relevant `environments/` folder.

* `undo!()` will revert the current project and manifest to the most recent snapshot.  

## Dependencies and Dependents

* `get_dependents("MyPackage", n = 1)` returns n-th order dependents of `MyPackage` (in the `General` registry.)

* `get_dependencies("SomePackage", n = 1)` returns n-th order dependencies of `SomePackage`.

## Environments

* `manifest!"..."` creates and activates a throwaway environment based on the contents of a `Manifest.toml`.
* `project!"..."` creates and activates a throwaway environment based on the contents of a `Project.toml`.
