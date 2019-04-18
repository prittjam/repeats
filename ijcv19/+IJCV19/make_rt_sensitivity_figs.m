function [] = make_rt_sensitivity_figs()
[solver_names,solver_list,colormap] = IJCV19.make_solver_list();

target_path = '/home/jbpritts/Documents/ijcv19/fig2/';
rt_wildcard = 'results/rt_sensitivity*.mat';
rt_listing = dir(rt_wildcard);
rt_file_path = [rt_listing(end).folder '/' rt_listing(end).name];

TEST.make_sensitivity_figs(rt_file_path,target_path,colormap, 'rt');