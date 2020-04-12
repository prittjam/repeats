%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = cvtk2_init()
[cvtk_base_path, name, ext] = fileparts(mfilename('fullpath'));
addpath(cvtk_base_path);