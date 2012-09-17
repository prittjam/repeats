function [] = scene_put_dr(img_id,dr)
global conn

cvdb_ins_dr(conn,img_id,dr);