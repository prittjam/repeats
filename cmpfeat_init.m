function [] = cmpfeat_init()
[cmpfeat_base_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(cmpfeat_base_path);
addpath('~/opt/wbs/matlab');
addpath('~/src/cmpfeat/slic');