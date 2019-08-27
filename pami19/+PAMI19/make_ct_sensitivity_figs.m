function [] = make_ct_sensitivity_figs()
[solver_names,solver_list,colormap] = PAMI19.make_solver_list();

target_path = '/home/jbpritts/Documents/pami19/fig2/';
ct_wildcard = 'results/ct_sensitivity*.mat';
ct_listing = dir(ct_wildcard);
ct_file_path = [ct_listing(end).folder '/' ct_listing(end).name];

TEST.make_sensitivity_figs(ct_file_path,target_path,colormap, 'ct');
