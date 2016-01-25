function R = test_pairwise(img_name)
cfg = CFG.get();
img = Img('data',imread(img_name));
cfg.spixel.region_size = max(10,min(80, sqrt(1.3*max(size(img.data))) ));
disp(cfg.spixel.region_size)
segments = SPIXEL.VlSlic.make(img,cfg.spixel);
R = SPIXEL.calc_pairwise(img,segments);
SPIXEL.draw_pairwise(img,segments,R);