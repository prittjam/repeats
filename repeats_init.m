function [] = repeats_init()
[cur_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(genpath(cur_path));

%if ~exist('ColumnType','file')
%    addpath([src_path '/ckvs']);
%end

features_init();
cvdb_init();
