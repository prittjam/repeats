function [] = repeats_init(src_path,opt_path)
[cur_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(genpath(cur_path))

if nargin < 1
    src_path = '~/src/';
end

%if ~exist('ColumnType','file')
%    addpath([src_path '/ckvs']);
%end

features_init();
