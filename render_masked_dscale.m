function [] = render_masked_dscale(results_file,mask)
results_file = '/home/jbpritts/src/repeats/results/WRAP.laf222_to_ql/20190331_111605/cropped_dartboard.mat';
mask = imread('/home/jbpritts/src/repeats/results/WRAP.laf222_to_ql/20190331_111605/cropped_dartboard_mask.png');
load(results_file);
res = res_list(1);
l = PT.renormI(model_list(1).l);
x = reshape(meas.x(:,unique(res.info.cspond(:,res.cs))),3,[]);
[sc_img,si_fn] = ...
    IMG.calc_dscale(size(img.data),model_list(1).l, ...
                    model_list(1).cc,model_list(1).q,x);
sc_img = 1./sc_img;
bwmask = mat2gray(mask);
bgimg = 0.5*img.data;
bwmask(bwmask == 0) = nan;
sc_image = bwmask.*sc_img;
scimg8 = im2uint8(ind2rgb(im2uint8(mat2gray(sc_image)),parula(256)));
bwmask = repmat(bwmask,1,1,3);
bgimg(bwmask==1) = scimg8(bwmask==1);
[~,img_name] = fileparts(results_file);
imwrite(bgimg,[img_name '_cs.jpg']);
