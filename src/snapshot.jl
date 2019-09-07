function snapshot!()
    ctx = Pkg.Types.Context();
    proj = ctx.env.project_file; 
    man = ctx.env.manifest_file; 

    cp(proj, joinpath(dirname(proj), "project_snapshot.toml"), force = true);
    cp(man, joinpath(dirname(proj), "manifest_snapshot.toml"), force = true);
end

function undo!()
    ctx = Pkg.Types.Context();
    snap_proj = joinpath(dirname(ctx.env.project_file), "project_snapshot.toml")
    snap_man = joinpath(dirname(ctx.env.manifest_file), "manifest_snapshot.toml")
    if isfile(snap_proj) && isfile(snap_man)
        cp(snap_proj, joinpath(dirname(snap_proj), "Project.toml"), force = true);
        cp(snap_man, joinpath(dirname(snap_proj), "Manifest.toml"), force = true);
        Pkg.activate(dirname(snap_proj))
    else 
        @info "No valid snapshot found."
    end
end