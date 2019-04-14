function [] = make_feasibility_figs()
[solver_names,solver_list,colormap] = IJCV19.make_solver_list();
src_path = 'ct_sensitivity_20190412.mat';
target_path = '/home/jbpritts/Documents/ijcv19/fig2/';
TEST.make_feasibility_figs(src_path, target_path, colormap);