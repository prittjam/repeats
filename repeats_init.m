%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = repeats_init()
[cur_path, name, ext] = fileparts(mfilename('fullpath'));
com.mathworks.services.Prefs.setBooleanPref('EditorGraphicalDebugging',false);
addpath(genpath(cur_path));

features_init();
cvdb_init();
