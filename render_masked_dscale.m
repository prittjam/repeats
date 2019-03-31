function [] = render_masked_dscale(results_file,mask)
load(results_file);
res = res_list(1);
l = PT.renormI(model_list(1).l);
x = reshape(meas.x(:,unique(res.info.cspond(:,res.cs))),3,[]);
[sc_img,si_fn] = ...
    IMG.calc_dscale(size(img.data),model_list(1).l, ...
                    model_list(1).cc,model_list(1).q,x);
sc_img = 1./sc_img;
bwmask = mat2gray(mask);
mask(mask < 0.95) = 0;
bwmask(bwmask == 0) = nan;
sc_image = bwmask.*sc_img;
scimg8 = ind2rgb(im2uint8(mat2gray(sc_image)),parula(256));
[~,img_name] = fileparts(results_file);
imwrite(scimg8,[img_name '_cs.jpg']);