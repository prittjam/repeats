src_path = '/home/jbpritts/Pictures/ijcv19/**/*.jpg';
repeats_init;
listing = dir(src_path);
dt = datestr(now,'yyyymmdd_HHMMSS');
solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);

listing = listing(9:end);
parfor k = 1:numel(listing)
    item = listing(k);
    img_path = fullfile(item.folder,item.name);
    [model_list,res_list,stats_list,meas,img] = do_one_img(img_path,solver);
    save_results(img_path,dt,model_list, ...
                 res_list,stats_list,meas,img);
end
