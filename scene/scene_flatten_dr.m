function dr2 = scene_flatten_dr(dr)
dr2 = struct('geom',[],'sifts',[],'id',[]);
fn = fieldnames(dr);

for j = 1:numel(fn)
    tp = fn{j};
    if isfield(dr.(tp),'geom')
        dr2.geom = cat(2,dr2.geom,dr.(tp).geom);
        dr2.sifts = cat(2,dr2.sifts,dr.(tp).sifts);
        dr2.id = cat(2,dr2.id,dr.(tp).id);
    else
        fn2 = fieldnames(dr.(tp));
        for z = 1:numel(fn2)
            subtype = fn2{z};
            if (strcmp(subtype,'img_id'))
                continue;
            end
            dr2.geom = cat(2,dr2.geom,dr.(tp).(subtype).geom);
            dr2.sifts = cat(2,dr2.sifts,dr.(tp).(subtype).sifts);
            dr2.id = cat(2,dr2.id,dr.(tp).(subtype).id);            
        end
    end
end