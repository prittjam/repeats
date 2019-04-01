src_path = '/home/jbpritts/Pictures/ijcv19/**/*.jpg';
repeats_init;
listing = dir(src_path);
dt = datestr(now,'yyyymmdd_HHMMSS');
results_path = fullfile('results',class(solver.solver_impl),dt);
solver = WRAP.lafmn_to_qAl(WRAP.laf22_to_ql);
%solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);

listing = listing(1:5);
for k = 1:numel(listing)
    item = listing(k);
    img_path = fullfile(item.folder,item.name);
    [model_list,res_list,stats_list,meas,img] = do_one_img(img_path,solver);
    save_results(results_path,img_path,dt, ...
                 model_list,res_list,stats_list,meas,img);
end
