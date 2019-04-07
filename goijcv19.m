repeats_init();
ransac_settings = ...
    { 'min_trial_count',500, ...
      'max_trial_count',500, ...
      'reprojT', 7 } ;
dr_settings = ...
    { 'desc_cutoff', 150 }; 
varargin = { ransac_settings{:} dr_settings{:} };

src_path = '/home/jbpritts/Pictures/ijcv19/**/*.jpg';
src_path1 = '/home/jbpritts/Downloads/data/**/*.jpg';
src_path2 = '/home/jbpritts/Downloads/data/**/*.JPG';

solver_list{1} = WRAP.lafmn_to_qAl(WRAP.laf22_to_ql);
solver_list{2} = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);

solver_names = {'$\mH22\{\,\lambda\,\}_k$',
                '$\mH222\vl\lambda$'};

solver_category_list = categorical([1:numel(solver_names)], ...
                                   [1:numel(solver_names)], ...
                                   solver_names, ...
                                   'Ordinal', true);
listing1 = dir(src_path1); 
listing2 = dir(src_path2);
listing = [listing1;listing2];

for k = 1:numel(listing)
    splt = strsplit(listing(k).folder,'/');
    all_camera_names{k} = splt{end};
end

[camera_names,~,ind] = unique(all_camera_names);
camera_category_list = categorical(ind, ...
                                   [1:numel(ind)], ...
                                   camera_names(ind), ...
                                   'Ordinal', true);

dt = datestr(now,'yyyymmdd_HHMMSS');
summary_list = cell2table(cell(0,6),'VariableNames', ...
                          {'solver_name', 'camera_name', 'model_list', ...
                    'res_list', 'stats_list', 'img_path'});
for k1 = 1:numel(solver_list)
    solver = solver_list{k1};
    for k2 = 1:numel(listing)
        item = listing(k2);
        img_path = fullfile(item.folder,item.name);
        [model_list,res_list,stats_list,meas,img] = ...
            do_one_img(img_path,solver,varargin{:});
        summary_row = ...
            { solver_category_list(k1), camera_category_list(k2), ...
              model_list, res_list, stats_list, img_path };        
        tmp_summary = summary_list;
        summary_list = [tmp_summary;summary_row]; 
    end
    save(strcat('results/sattler_', dt, '.mat'), 'summary_list');
end