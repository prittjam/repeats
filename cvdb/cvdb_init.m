function [] = cvdb_init()
[cvdb_base_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(cvdb_base_path);