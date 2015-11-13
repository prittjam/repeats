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
addpath(genpath('~/opt/bgl/matlab'));

if usejava('jvm')
    x = dbstatus; 
    javaaddpath(fullfile([cvdb_base_path '/vendor/mysql-connector/mysql-connector-' ...
                        'java-5.1.14-bin.jar']));

    javaaddpath(fullfile([ckvs_base_path '/target/ckvs-0.0.1-jar-with-dependencies.jar']));
    
    dbstop(x);
else
    display('Java is not available. Database functionality will not work.');
end