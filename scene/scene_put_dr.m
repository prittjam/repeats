function [] = scene_put_dr(cfg,cfg_id,img_id,dr)
global conn

cvdb_ins_dr(conn,cfg,img_id,cfg_id,dr)

