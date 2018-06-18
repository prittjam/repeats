function [] = make_figures(img_name)
cfg = CFG.get();
img = Img('data',imread(img_name));
segments = SPIXEL.Seeds.make(img,cfg.spixel);
R = SPIXEL.calc_pairwise(img,segments,false);
alpha = SPIXEL.draw_pairwise(img,segments,R);

square = strel('square', 4);
alpha1 = imerode(1-alpha,square);

[cimg,r] = imcrop(img.data);
calpha = imcrop(alpha1,r);
zrs = zeros(size(cimg));
imwrite(zrs,'temp.png','alpha',calpha);