function [stereo_set,num_pairs] = scene_get_stereo_set(stereo_set_name)
global conn;
stereo_set = cvdb_sel_stereo_set(conn,stereo_set_name);
num_pairs = numel(stereo_set);