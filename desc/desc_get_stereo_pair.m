function res = desc_get_stereo_pair(desc_defs,pair,descriptors,dr)
res{1} = desc_get_img(desc_defs,descriptors,dr{1},pair.img1);
res{2} = desc_get_img(desc_defs,descriptors,dr{2},pair.img2);