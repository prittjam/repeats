function dr = scene_flatten_dr(cdr)
dr.gid = [cdr(:).gid];
dr.geom(:,dr.gid) = [cdr(:).geom];
dr.u(:,dr.gid) = [cdr(:).u];
dr.sifts(:,dr.gid) = [cdr(:).sifts];
dr.xsifts(:,dr.gid) = [cdr(:).xsifts];
dr.s(:,dr.gid) = [cdr(:).s];
dr.gid = [1:numel(dr.gid)];