module PkgUtils

# deps
using Pkg, Pkg.TOML, Statistics, LightGraphs, MetaGraphs
using SnoopCompile

# file includes
include("dependencies.jl")
# include("treeshaker.jl")
include("snapshot.jl")
include("environments.jl")

# exports
export get_dependents, get_dependencies, get_latest_version
export snapshot!, undo!
export @project!_str, @manifest!_str

end
