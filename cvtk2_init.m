function [] = cvtk2_init()
[cvtk_base_path, name, ext] = fileparts(mfilename('fullpath'));
addpath(genpath(cvtk_base_path));