function [] = test_pairwise(img_name)
cfg = CFG.get();
img = Img('data',imread(img_name));
segments = SPIXEL.VlSlic.make(img,cfg.spixel);
R = SPIXEL.calc_pairwise(img,segments);
SPIXEL.draw_pairwise(img,segments,R);