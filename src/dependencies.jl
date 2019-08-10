# Thanks to Seth Bromberger for writing almost all of this code
REGDIR = joinpath(DEPOT_PATH[1], "registries", "General")

version_in_range(v, s) = v in Pkg.Types.VersionSpec(s)
get_pkg_dir(s) = "$REGDIR/$(uppercase(s[1]))/$s"

# Put this on top so that we can use it for variables, etc. 
function build_graph(r=REGDIR; omit_packages=[])
    pkglist = make_pkg_list(r, omit_packages)
    pkgrev = Dict((k, v) for (v, k) in enumerate(pkglist))

    g = MetaDiGraph(length(pkglist))
    for p in pkglist
        v = pkgrev[p]
        set_prop!(g, v, :name, p)
        deps = get_deps(p)
        setdiff!(deps, omit_packages)
        for d in deps
            w = pkgrev[d]
            add_edge!(g, v, w)
        end
    end
    set_indexing_prop!(g, :name)
    return (g, reverse(g), pkglist, pkgrev)
end
g, rev_g, pkglist, pkgrev = build_graph()


"""
See all n-th order dependencies of a package. 
"""
function get_dependents(s, n = 1)
    s_index = pkgrev[s]
    new_g = egonet(rev_g, s_index, n)
    dependents = [props(new_g, dependent)[:name] for dependent in vertices(new_g)[2:end]]
end


# Old stuff 
"""
Get the latest version of a package by
reading Versions.toml.
"""
function get_latest_version(s)
    d = get_pkg_dir(s)
    maxver = v"0.0.0"
    !isfile("$d/Versions.toml") && return maxver
    for l in readlines("$d/Versions.toml")
        if startswith(l, "[")
            v = VersionNumber(strip(l, ['[',']','\"']))
            if v > maxver
                maxver = v
            end
        end
    end
    return maxver
end

"""
Get all the dependencies of a package by
reading Deps.toml.
"""
function get_dep_dict(s)
    deps = Dict{String, Vector{String}}()

    d = get_pkg_dir(s)
    vrange = ""
    !isfile("$d/Deps.toml") && return deps
    for l in readlines("$d/Deps.toml")
        if startswith(l, "[")
            vrange = strip(l, ['[',']','\"'])
            # println("l = $l, vrange = $vrange")
            deps[vrange] = Vector{String}()
        else
            pkg = split(l, " ")[1]
            if pkg != ""
                push!(deps[vrange], pkg)
            end
        end
    end
    return deps
end

"""
Given a package name, return a vector
of all _direct_ depedencies.
"""
function get_dependencies(s)
    depdict = get_dep_dict(s)
    depset = Set{String}()
    maxver = get_latest_version(s)
    for (vrange, deps) in depdict
        # println("vrange = $vrange, deps = $deps")
        if version_in_range(maxver, vrange)
            union!(depset, deps)
        end
    end
    return collect(depset)
end

"""
Given a dependency graph and a package
name, return the gdistances output for
the dependency tree of the package along
with the maximum and average depths.
"""
function get_transitive_dependency_stats(g, s)
    d = gdistances(g, g[s, :name])
    fd = filter(x->x < typemax(x), d)
    return(d, maximum(fd), median(fd))
end


function make_pkg_list(r, omit_packages)
    f = "$r/Registry.toml"
    t = Pkg.TOML.parsefile(f)["packages"]

    omitset = Set(omit_packages)
    pkglist = Set(v["name"] for (_, v) in t)
    for p in pkglist
        # println("making $p")
        depset = Set(get_deps(p))
        union!(pkglist, depset)
    end
    setdiff!(pkglist, omitset)
    return sort(collect(pkglist))
end


# gets all dependencies for a given package.
"""
Given a graph, a package name, a preinitialized
buffer, and a forward index (for graph metadata),
get all transitive and direct dependencies for
the package and return as a vector of names.
"""
function get_all_deps!(g, s, buf, fi)
    v = g[s, :name]
    gdistances!(g, v, buf)
    deps = [fi[i] for (i, x) in enumerate(buf) if 0 < x < typemax(v)]
    return deps
end


function get_all_deps_all_packages(g)
    d = Dict{String, Tuple{Int, Float64, Vector{String}}}()
    fi = [get_prop(g, v, :name) for v in vertices(g)]
    l = length(fi)
    buf = fill(typemax(eltype(g)), nv(g))
    for p in fi
        ad = get_all_deps!(g, p, buf, fi)
        n = length(ad)
        d[p] = (n, n/l, ad)
        fill!(buf, typemax(eltype(g)))
    end
    return sort(collect(d), by=x->x[2][1], rev=true)
end
