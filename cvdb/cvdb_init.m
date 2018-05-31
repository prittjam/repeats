function [] = cvdb_init(ckvs_base_path)
if nargin < 1
    wbs_base_path = '../wbs';
end

if nargin < 2
    ckvs_base_path = '../ckvs';
end

[cvdb_base_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(cvdb_base_path);
addpath(fullfile(cvdb_base_path,'jsonlab'));

