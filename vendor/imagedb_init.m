function [] = imagedb_init()
    [base_path, name, ext] = fileparts(mfilename('fullpath'));
    
    addpath([base_path '/matlab_interface']);
    addpath([base_path '/matlab_interface/uniaccess']);