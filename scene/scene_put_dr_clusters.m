function [] = scene_put_dr_clusters(img_id,clusters)
global conn

cvdb_ins_dr_clusters(conn,img_id,dr);