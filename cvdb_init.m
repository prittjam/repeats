function conn = cvdb_init(wbs_base_path)
if nargin < 1
    wbs_base_path = '../wbs';
end
[cvdb_base_path, name, ext] = fileparts(mfilename('fullpath'));
addpath(cvdb_base_path);

if usejava('jvm')
    x = dbstatus; 
    javaaddpath(fullfile([cvdb_base_path '/vendor/mysql-connector/mysql-connector-' ...
                        'java-5.1.14-bin.jar']));
    
    javaaddpath(fullfile(wbs_base_path,'matlab','ckvs','target',...
                         'ckvs-0.0.1-jar-with-dependencies.jar'));
    dbstop(x);
else
    display('Java is not available. Database functionality  will not work.');
end
    
% add widebaseline stereo dependencies
addpath([wbs_base_path '/wbs-demo']); 

old_folder = cd([wbs_base_path '/wbs-demo']);
setpaths;
cd(old_folder);

addpath([wbs_base_path '/matlab/utils']);
addpath([wbs_base_path '/matlab/utils/json']);
addpath([wbs_base_path '/matlab/utils/uniaccess']);
addpath(genpath([wbs_base_path '/matlab/ckvs']));

old_folder = cd([wbs_base_path '/matlab']);
setpaths;
cd(old_folder);

addpath(genpath('/home.stud/prittjam/opt/share/bgl/matlab'));

