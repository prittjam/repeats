function [] = stability()
dt = datestr(now,'yyyymmdd_HHMMSS');

if ~exist('results', 'dir')
    mkdir('results');
end

nx = 1000;
ny = 1000;
cc = [nx/2+0.5; ...
      ny/2+0.5];

[solver_names,solver_list,colormap] = IJCV19.make_stabilty_solver_list();

[res,gt,cam] = ...
    TEST.sensitivity(solver_names,solver_list,solver_names, ...
                     'nx', nx,'ny',ny, ...
                     'cc', cc, 'RigidXform','Rt', ...
                     'CcdSigmaList', 0, 'NumScenes',100);

save(strcat('results/stability', dt, '.mat'), 'res','gt','cam');