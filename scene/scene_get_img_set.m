function img_set = scene_get_img_set(img_set_name)
global conn
img_set = cvdb_sel_img_set(conn, img_set_name);