function [] = make_stability_fig()
[solver_names,solver_list,colormap,linestylemap] = PAMI19.make_stability_solver_list();
target_path = '/home/jbpritts/Documents/pami19/fig2/';
wildcard = 'results/stability*.mat';
stability_listing = dir(wildcard);
stability_file_path = [stability_listing(end).folder '/' stability_listing(end).name];

TEST.make_stability_fig(stability_file_path,target_path,colormap,linestylemap)


