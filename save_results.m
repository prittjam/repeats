function [] = save_results(img_path,date_time, model_list, ...
                           res_list,stats_list,meas,img)

results_dir = ['./results/' date_time];
if ~exist(results_dir, 'dir')
    mkdir(results_dir);
end

save(['output/' img_name '.mat'],'model_list', ...
     'res_list','stats_list','meas','img');
