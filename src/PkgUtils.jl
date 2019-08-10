module PkgUtils

# deps 
using Pkg, Statistics, LightGraphs, MetaGraphs

# file includes 
include("dependencies.jl")
include("treeshaker.jl")

# exports 
export get_dependents, get_dependencies, trim_dependencies

end # module
