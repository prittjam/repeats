function [] = faff_test()

global CFG;
global DR;
global TC;
global RES;


%results.(experiment_list{m}).inl{(j*k*z-1)*reps+n} = inl;
%results.(experiment_list{m}).num_inliers = ...
%    cat(1,results.(experiment_list{m}).num_inliers, ...
%        run_results.num_inliers);
%results.(experiment_list{m}).num_trials = ...
%    cat(1,results.(experiment_list{m}).num_trials, ...
%        run_results.num_trials);
%fprintf(strcat(experiment_list{m}, [' found ' ...
%                    '%d inliers in %d trials\r\n']),run_results.num_inliers, run_results.num_trials);
%%for j = 1:j*k*z*n
%    for i = 1:length(experiment_list)
%        results.(experiment_list{i}).Ia_p = ...
%            length(intersect(results.(experiment_list{i}).inl{j}, results.(experiment_list{1}).inl{j}));
%    end   
%end
end
 
%save(results_path,'results','experiment_list');
%clear results;
%faff_test_plot_results(results_path);
%end
% 
function [option_list] = get_option_list(input_list)
r = input_list;
i = 1;
while (~isempty(r))
    [val_string, r] = strtok(r, ',');
    option_list{i} = strtrim(val_string);
    i = i+1;
end
end
