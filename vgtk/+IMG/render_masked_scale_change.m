function bgimg = render_masked_scale_change(img,meas,model,res,mask)
l = PT.renormI(model.l);
x = reshape(meas.x(:,unique(res.info.cspond(:,res.cs))),3,[]);
[sc_img,si_fn] = ...
    IMG.render_scale_change(size(img),model.l, ...
                            model.cc,model.q,x);
sc_img = 1./sc_img;
bwmask = mat2gray(mask);
bgimg = img;
bwmask(bwmask == 0) = nan;
sc_image = bwmask.*sc_img;
scimg8 = im2uint8(ind2rgb(im2uint8(mat2gray(sc_image)),parula(256)));
bwmask = repmat(bwmask,1,1,3);
bgimg(bwmask==1) = scimg8(bwmask==1);
