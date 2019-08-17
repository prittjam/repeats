function [] = rt_sensitivity()
dt = datestr(now,'yyyymmdd_HHMMSS');

nx = 1000;
ny = 1000;
cc = [nx/2+0.5; ...
      ny/2+0.5];

[solver_names,solver_list,colormap] = PAMI19.make_solver_list();
[res,gt,cam] = TEST.sensitivity(solver_names([3:11]), ...
                                solver_list([3:11]), ...
                                solver_names, ...
                                'nx',nx,'ny',ny,'cc',cc, ...
                                'RigidXform','Rt');

if ~exist('results', 'dir')
    mkdir('results');
end
save(strcat('results/rt_sensitivity_', dt, '.mat'), ...
     'res','gt','cam');