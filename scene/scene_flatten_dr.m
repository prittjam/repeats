function dr = scene_flatten_dr(dr_defs,detectors,desc)
kkk = 3;
dr.desc = [];
dr.affpt = [];
dr.class = [];
dr.num_dr = 0;

for k = 1:numel(detectors)
    num_dr = numel(desc{k}.affpt);
    dr.num_dr = dr.num_dr+num_dr;
    dr.desc = cat(2,dr.desc,reshape([desc{k}.affpt(:).desc],128,[]));
    dr.affpt = cat(2,dr.affpt,...
                   reshape([ ...
                       [desc{k}.affpt(:).x]; ...
                       [desc{k}.affpt(:).y]; ...
                       [desc{k}.affpt(:).a11]; ...
                       [desc{k}.affpt(:).a12]; ...
                       [desc{k}.affpt(:).a21]; ...
                       [desc{k}.affpt(:).a22] ],6,[]));
    dr.class = cat(2,dr.class,bitor([ desc{k}.affpt(:).class ], ...
                     repmat(bitshift(dr_get_drids(dr_defs,detectors(k)),1),1,num_dr)));
end
%dr.gid = [cdr(:).gid];
%dr.geom(:,dr.gid) = [cdr(:).geom];
%dr.u(:,dr.gid) = [cdr(:).u];
%dr.sifts(:,dr.gid) = [cdr(:).sifts];
%dr.xsifts(:,dr.gid) = [cdr(:).xsifts];
%dr.s(:,dr.gid) = [cdr(:).s];
%dr.gid = [1:numel(dr.gid)];