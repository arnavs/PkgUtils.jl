module PkgUtils

# deps 
using Pkg, Statistics, LightGraphs, MetaGraphs
using SnoopCompile

# file includes 
include("dependencies.jl")
# include("treeshaker.jl")
include("snapshot.jl")

# exports 
export get_dependents, get_dependencies
export snapshot!, undo!
end # module
