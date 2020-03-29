deps = get_dependencies("Expectations")
@test deps == ["Compat", "Distributions", "FastGaussQuadrature", "SpecialFunctions"]
@test PkgUtils.get_latest_version("Expectations") == v"1.3.0" # will fail if this version is bumped
