function [] = go()
addpath('..');
dr = SIM.make_dr('outlier_pct',0, ...
                 'ccd_sigma',0, ...
                 'desc_xform','SIFT.sift_to_rootsift', ...
                 'sift_sigma',0.0);
G = [dr(:).drid];
figure;
LAF.draw_groups(gca,[dr(:).u],G);
res = struct('cs',ones(1,size([dr(:).u],2)));
select_models(dr,G,eye(3,3),res);
cvpr14(dr);