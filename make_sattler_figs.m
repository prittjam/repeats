function [] = make_sattler_figs()
%res1 = load('results/WRAP.laf22_to_ql/20190330_200119/cropped_dartboard.mat');
res2 = load(['results/WRAP.laf222_to_ql/20190330_202246/' ...
             'cropped_dartboard.mat']);

figure;
plot(res1.resu


local_stats = [res2.stats_list(1).local_list(:)];
local_res = [local_stats(:).res]
local_loss = [local_res(:).loss];

global_stats = [res2.stats_list(1).local_list(:)];
global_res = [local_stats(:).res];
global_loss = [local_res(:).loss];
