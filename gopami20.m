repeats_init();
ransac_settings = ...
    { 'min_trial_count',150, ...
      'max_trial_count',150, ...
      'reprojT', 7 } ;
dr_settings = ...
    { 'desc_cutoff', 150 }; 
varargin = { ransac_settings{:} dr_settings{:} };

[solver_names,solver_list,colormap] = PAMI19.make_solver_list();

solver_names = solver_names([1 4 6:10]);
solver_list = solver_list([1 4 6:10]);
dt = datestr(now,'yyyymmdd_HHMMSS');

M = 100;
num_ex = M*numel(solver_names);
K = numel(solver_names);

summary_list = cell(num_ex,6);
num_cores = numel(solver_names);
table = cell(num_ex,6);

for k2 = 1:M
    summary_rows = cell(numel(solver_names), ...
                        size(summary_list,2));
    parfor (k1 = 1:numel(solver_list),num_cores)
    %    for k1 = 1:numel(solver_list)
        solver = solver_list(k1);
        img_path = ['img' num2str(k2)];
        [model_list,res_list,stats_list] = ...
            do_one_synthetic_img(solver,varargin{:});
        summary_row = { solver_names{k1}, 'synthetic', ...
                        model_list, res_list, stats_list, ...
                        img_path }; 
        summary_rows(k1,:) = summary_row;
    end
    summary_list(numel(solver_names)*(k2-1)+1:numel(solver_names)*(k2-1)+numel(solver_list),:) = ...
        summary_rows;
end

summary_list = cell2table(summary_list, ...
                          'VariableNames', ...
                          {'solver_name', 'camera_name', ...
                    'model_list', 'res_list', ...
                    'stats_list', 'img_path'});


if ~exist('results', 'dir')
    mkdir('results');
end
save(strcat('results/sattler_', dt, '.mat'), 'summary_list');
disp(['Finished!']);