function [] = ct_sensitivity()
dt = datestr(now,'yyyymmdd_HHMMSS');

nx = 1000;
ny = 1000;
cc = [nx/2+0.5; ...
      ny/2+0.5];

[solver_names,solver_list,colormap] = PAMI19.make_solver_list();

[res,gt,cam] = TEST.sensitivity(solver_names, ...
                                solver_list, ...
                                solver_names, ...
                                'nx',nx,'ny',ny,'cc',cc, ...
                                'RigidXform','t', ...
                                'numscenes', 10);

if ~exist('results', 'dir')
    mkdir('results');
end

save(strcat('results/ct_sensitivity_', dt, '.mat'), ...
     'res','gt','cam');