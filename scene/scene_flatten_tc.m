function m2 = scene_flatten_tc(m)
fn = fieldnames(m);
m2 = [];
for j = 1:numel(fn)
    tp = fn{j};
    if (isreal(m.(tp)))
        m2 = cat(2,m2,m.(tp));
    else
        fn2 = fieldnames(m.(tp));
        for z = 1:numel(fn2)
            subtype = fn2{z};
            if (strcmp(subtype,'img_id'))
                continue;
            end
            m2 = cat(2,m2,m.(tp).(subtype));
        end
    end
end