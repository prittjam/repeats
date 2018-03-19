function res = merge_sensitivity()
sensitivity = load('sensitivity_20180311.mat');
solver_list = unique(sensitivity.solver);
merge_sensitivity = load('sensitivity_to_merge.mat');
data1 = innerjoin(sensitivity.res,sensitivity.gt, ...
                 'LeftKeys','ex_num','RightKeys','ex_num');
data2 = innerjoin(merge_sensitivity.res,merge_sensitivity.gt,...
                  'LeftKeys','ex_num','RightKeys','ex_num');
Lia = ismember(res1.solver, ...
               setdiff(solver_list, ...
                       {'$\mH22\vl s$'}));

keyboard;

keyboard;
res = [res1(Lia,:); res2];
keyboard;
