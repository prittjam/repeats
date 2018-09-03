repeats_init();
img_name = 'pattern1b';
load(['cvpr18/output/' img_name '_H3qlsu.mat']);
img = Img('url',['img/' img_name '.jpg']);  
cid_cache = CidCache(img.cid, ...
                     { 'read_cache', true, 'write_cache', true });
dr = DR.get(img,cid_cache, ...
                {'type','all', ...
                 'reflection', false });
x = [dr(:).u];

output_all_planes(x,img,model_list);