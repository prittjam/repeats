function cvdb_addpaths(wbs_base_path)
if nargin < 1
    wbs_base_path = '../wbs';
end

[cvdb_base_path, name, ext] = fileparts(mfilename('fullpath'));

addpath(genpath(cvdb_base_path));

javaaddpath(fullfile([cvdb_base_path '/vendor/mysql-connector/mysql-connector-' ...
             'java-5.1.14-bin.jar']));

javaaddpath(fullfile(wbs_base_path,'matlab','ckvs','target',...
                     'ckvs-0.0.1-jar-with-dependencies.jar'));


% add widebaseline stereo dependencies
addpath([wbs_base_path '/wbs-demo']); 

old_folder = cd([wbs_base_path '/wbs-demo']);
setpaths;
cd(old_folder);

addpath([wbs_base_path '/matlab/utils']);
addpath([wbs_base_path '/matlab/utils/json']);
addpath([wbs_base_path '/matlab/utils/uniaccess']);

old_folder = cd([wbs_base_path '/matlab']);
setpaths;
cd(old_folder);