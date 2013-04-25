function dr_stereo_set = scene_get_stereo_set_dr(detectors)
dr_set = scene_get_img_set_dr(detectors);
dr_stereo_set = reshape(dr_set,2,[]);