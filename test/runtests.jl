using PkgUtils
using Pkg, Test, UUIDs

@elapsed begin
    @time @testset "Dependencies" begin include("dependencies.jl") end
    @time @testset "Environments" begin include("environments.jl") end
end
