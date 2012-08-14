function num_dr = scene_get_cmbnd_num_dr(cdr)
num_dr = 0;

for dr = cdr
    num_dr = num_dr+sum(dr.s(end,:));
end