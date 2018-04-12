function [] = repeats_init(src_path,opt_path)
[cur_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(genpath(cur_path))

if nargin < 1
    src_path = '~/src/';
end

if nargin < 2
    opt_path = '~/opt/';
end

addpath([opt_path 'mex']);

if ~exist('+MMS','dir')
    addpath(fullfile([opt_path 'mex']));
end

if ~exist('ColumnType','file')
    addpath([src_path '/ckvs']);
end

if ~exist('cvdb_init','file')
    cvdb_path = fullfile(src_path, '/cvdb');
    cd(cvdb_path);
    feval('cvdb_init'); 
    cd(cur_path);
end

features_init();
