%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = repeats_init()
[cur_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(genpath(cur_path));

%if ~exist('ColumnType','file')
%    addpath([src_path '/ckvs']);
%end

features_init();
cvdb_init();
