"""
    manifest!"..."

Create and activate a throwaway environment based on the contents of a `Manifest.toml`.
The environment is deleted at exit.

Use this macro to paste a manifest file into a Julia script,
ensuring that it will always run with the exact set of desired dependencies.
"""
macro manifest!_str(s::AbstractString)
    quote
        env = _env_dir()
        write(joinpath(env, "Manifest.toml"), $s)
        deps = Dict(name => pkgs[1]["uuid"] for (name, pkgs) in TOML.parse($s))
        project = Dict("deps" => deps)
        open(io -> TOML.print(io, project), joinpath(env, "Project.toml"), "w")
        _activate(env)
    end
end

"""
    project!"..."

Create and activate a throwaway environment based on the contents of a `Project.toml`.
The environment is deleted at exit.

Use this macro to paste a project file into a Julia script,
ensuring that it will always run with the defined set of desired dependencies.
"""
macro project!_str(s::AbstractString)
    quote
        env = _env_dir()
        write(joinpath(env, "Project.toml"), $s)
        _activate(env)
    end
end

function _env_dir()
    dir = mktempdir()
    atexit(() -> rm(dir; recursive=true, force=true))
    return dir
end

function _activate(env::AbstractString)
    Pkg.activate(env)
    Pkg.instantiate()
end
