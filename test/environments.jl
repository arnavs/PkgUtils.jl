function do_env_test(min::VersionNumber, max::VersionNumber)
    if isdefined(Pkg, :dependencies)
        deps = Pkg.dependencies()
        uuid = UUID("7876af07-990d-54b4-ab0e-23690620f79a")
        @test haskey(deps, uuid) && min <= deps[uuid].version <= max
    else
        deps = Pkg.installed()
        @test haskey(deps, "Example") && min <= deps["Example"] <= max
    end
end

proj = Base.active_project()
try
    project!"""
    [deps]
    Example = "7876af07-990d-54b4-ab0e-23690620f79a"

    [compat]
    Example = "0.4"
    """
    do_env_test(v"0.4", v"0.4.99")

    manifest!"""
    # This file is machine-generated - editing it directly is not advised

    [[Example]]
    git-tree-sha1 = "46e44e869b4d90b96bd8ed1fdcf32244fddfb6cc"
    uuid = "7876af07-990d-54b4-ab0e-23690620f79a"
    version = "0.5.3"
    """
    do_env_test(v"0.5.3", v"0.5.3")
finally
    proj === nothing ? Pkg.activate() : Pkg.activate(proj)
end
