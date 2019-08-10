module PkgUtils

# deps 
using Pkg, Statistics, LightGraphs, MetaGraphs

# file includes 
include("dependencies.jl")

# exports 
export get_dependents, get_dependencies

end # module
