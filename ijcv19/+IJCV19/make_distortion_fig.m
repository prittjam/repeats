function [] = make_distortion_fig()
[solver_names,solver_list,colormap] = IJCV19.make_solver_list();

target_path = '/home/jbpritts/Documents/ijcv19/fig2/';
wildcard = 'results/distortion*.mat';
listing = dir(wildcard);
file_path = [listing(end).folder '/' listing(end).name];

TEST.make_distortion_fig(file_path,target_path,colormap);