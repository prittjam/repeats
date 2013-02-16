function [] = scene_put_dr_clusters(dr,clusters)
global conn

cvdb_ins_dr_clusters(conn,dr.img_id,dr,clusters);