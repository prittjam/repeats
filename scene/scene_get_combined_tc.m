function tc = scene_get_combined_tc(dr1,dr2,cfg)
if nargin < 3
    cfg = scene_make_tc_cfg();
end

tc = struct('m',[]);

for k = 1:numel(dr1)
    tc(k).m = scene_get_tc(dr1(k),dr2(k),cfg);
end