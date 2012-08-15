function cvdb_addpaths(wbs_base_path)
if nargin < 1
    wbs_base_path = '../wbs';
end

[cvdb_base_path, name, ext] = fileparts(mfilename('fullpath'));

addpath([cvdb_base_path '/ins']);
addpath([cvdb_base_path '/upd']);
addpath([cvdb_base_path '/sel']);
addpath([cvdb_base_path '/util']);
addpath([cvdb_base_path '/scene']);
addpath([cvdb_base_path '/serialization']);

javaaddpath([cvdb_base_path '/vendor/mysql-connector/mysql-connector-' ...
             'java-5.1.14-bin.jar']);
javaaddpath([cvdb_base_path '/vendor/imagedb/imagedb.jar']);
javaaddpath([cvdb_base_path '/vendor/imagedb/imtools.jar']);

% add widebaseline stereo dependencies
addpath([wbs_base_path '/wbs-demo']); 

old_folder = cd([wbs_base_path 'wbs-demo/']);
setpaths;
cd(old_folder);

addpath([wbs_base_path '/matlab/utils']);
addpath([wbs_base_path '/matlab/utils/json']);
addpath([wbs_base_path '/matlab/utils/uniaccess']);



