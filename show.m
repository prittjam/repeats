clear all;
img_name = 'cropped_dartboard';
%img_name = 'pattern1b'
%img_name = 'pavement'
%img_name = 'coke'
%img_name = 'train'
%img_name = 'fisheye'
%img_name = 'raw'


load(['output/' img_name '.mat']);

k = 1;

ind = find(~isnan(model_list(k).Gm));
v = reshape(meas.x(:,unique(res_list.info.cspond(:,res_list.cs))),3,[]);
cc = model_list(k).cc;
q = model_list(k).q;

inlx = unique(res_list.info.cspond(:,res_list.cs));
output_one_plane(img.data,model_list(k).H,cc,q,v);