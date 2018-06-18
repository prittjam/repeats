function [] = test_watershed_slic(img_name)
cfg = CFG.get();
img = Img('data',imread(img_name));
cfg.spixel.region_size = max(10,min(80, sqrt(1.3*max(size(img.data))) ));
disp(cfg.spixel.region_size);
segments0 = SPIXEL.VlSlic.make(img,cfg.spixel);

nspixel = size(img.data,1)*size(img.data,2)/(cfg.spixel.region_size^2);
[l, Am, C] = slic(img.data, nspixel, 10, 1, 'median');
lc = spdbscan(l, C, Am, 5);

% wshed = SEGM.get_watershed(img.data);

% segments = SEGM.join(segments0,wshed);

figure;
subplot(2,2,1);
imshow(img.data);
SPIXEL.draw(gca,segments0);
title('vlslic');

subplot(2,2,3);
imshow(img.data);
SPIXEL.draw(gca,l);
title('kovasislic');

subplot(2,2,2);
imshow(img.data);
title('image');

subplot(2,2,4);
imshow(img.data);
SPIXEL.draw(gca,lc);
title('spdbscan');

