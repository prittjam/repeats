function [] = cvtk2_init()
[cvtk_base_path, name, ext] = fileparts(mfilename('fullpath'));
addpath(cvtk_base_path);