function [] = make_cdf_fig()
[solver_names,solver_list,colormap] = IJCV19.make_solver_list();

target_path = '/home/jbpritts/Documents/ijcv19/fig2/';
ct_wildcard = 'results/ct_sensitivity*.mat';
ct_listing = dir(ct_wildcard);
ct_file_path = [ct_listing(end).folder '/' ct_listing(end).name];

TEST.make_cdf_warp_fig(ct_file_path,target_path,colormap);