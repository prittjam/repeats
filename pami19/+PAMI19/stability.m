function [] = stability()
dt = datestr(now,'yyyymmdd_HHMMSS');

if ~exist('results', 'dir')
    mkdir('results');
end

nx = 1000;
ny = 1000;
cc = [nx/2+0.5; ...
      ny/2+0.5];

[solver_names,solver_list] = PAMI19.make_stability_solver_list();

[res,gt,cam] = ...
    TEST.sensitivity(solver_names,solver_list,solver_names, ...
                     'nx', nx, 'ny', ny, ...
                     'cc', cc, 'RigidXform', 't', ...
                     'CcdSigmaList', 0, ...
                     'NumScenes', 5000, ...
                     'SamplesDrawn', 1);

if ~exist('results', 'dir')
    mkdir('results');
end

save(strcat('results/stability_', dt, '.mat'), 'res','gt','cam');