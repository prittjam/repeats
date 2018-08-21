function [] = demo()
repeats_init();
[cur_path, name, ext] = fileparts(mfilename('fullpath'));
%cvpr14_demo([cur_path '/img']);

cvpr18_demo([cur_path '/img']);