function [] = greedy_repeats_init(src_path,opt_path)
set(0,'DefaultFigureRenderer','OpenGL');
set(0,'DefaultFigureRendererMode', 'manual');

if nargin < 1
    src_path = '~/src/';
end

if nargin < 2
    opt_path = '~/opt/';
end

[cur_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(cur_path);
addpath(genpath('external'));

%if ~exist('+LINE','dir')
%    lines_path = fullfile(cur_path, 'external/lines');
%    addpath(lines_path);
%end

if ~exist('MleImpl','file')
    mle_path = fullfile(src_path, '/repeat_lo');
    addpath(mle_path);
end

if ~exist('+MMS','dir')
    addpath(fullfile([opt_path 'mex']));
end

if ~exist('+RANSAC')
    addpath([src_path, '/ransac']);
end

if ~exist('cvtk2_init','file')
    cvtk_path = fullfile(src_path, '/cvtk2');
    cd(cvtk_path);
    feval('cvtk2_init');
    cd(cur_path);
end

if ~exist('cvdb_init','file')
    cvdb_path = fullfile(src_path, '/cvdb');
    cd(cvdb_path);
    feval('cvdb_init'); 
    cd(cur_path);
end

if ~exist('ColumnType','file')
    addpath([src_path '/ckvs']);
end

if ~exist('+DR','dir')
    cmpfeat_path = fullfile(src_path, 'cmpfeat');
    cd(cmpfeat_path);
    feval('cmpfeat_init'); 
    cd(cur_path);
end


if ~exist('get_dr')
    addpath(fullfile([src_path 'vl']));
end
