function R = test_pairwise(img_name)
cfg = CFG.get();
img = Img('data',imread(img_name));
% cfg.spixel.region_size = max(10,min(80, sqrt(1.3*max(size(img.data))) ));
% cfg.spixel.regularizer = 0.001;
segments = SPIXEL.Seeds.make(img,cfg.spixel);
R = SPIXEL.calc_pairwise(img,segments,false);
alpha = SPIXEL.draw_pairwise(img,segments,R);