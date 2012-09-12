function [] = scene_put_dr(cfg,img_id,dr)
global conn

cvdb_ins_dr(conn,cfg,img_id,dr);