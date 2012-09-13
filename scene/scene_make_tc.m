function m = scene_make_tc(dr1,dr2,cfg)
corr = match(dr1.sifts,dr2.sifts,cfg.wbs);
m = corr(1:2,:);