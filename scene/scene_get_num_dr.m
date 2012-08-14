function num_dr = scene_get_num_dr(cdr)
num_dr = 0;

for dr = cdr
    num_dr = num_dr+size(dr.geom,2);
end