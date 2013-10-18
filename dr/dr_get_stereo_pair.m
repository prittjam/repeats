function res = dr_get_stereo_pair(dr_defs,pair,detectors)
res{1} = dr_get_img(dr_defs,detectors,pair.img1);
res{2} = dr_get_img(dr_defs,detectors,pair.img2);