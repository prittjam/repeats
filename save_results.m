function [] = save_results(results_path,img_path,dt,model_list, ...
                           res_list,stats_list,meas,img) 
    if ~exist(results_path, 'dir')
        mkdir(results_path);
    end
    
    [~,img_name] = fileparts(img_path);
    mat_file_path = fullfile(results_path,[img_name '.mat']);
    save(mat_file_path, ...
         'model_list', 'res_list','stats_list','meas','img');

