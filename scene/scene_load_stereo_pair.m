function pair = scene_load_stereo_pair(pair)
[data,intensity,img_id] = scene_load_img(pair.img1);
pair.img1.data = data;
pair.img1.intensity = intensity;
pair.img1.img_id = img_id;

[data,intensity,img_id] = scene_load_img(pair.img2);
pair.img2.data = data;
pair.img2.intensity = intensity;
pair.img2.img_id = img_id;