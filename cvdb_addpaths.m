
[cvdb_base_path, name, ext] = fileparts(mfilename('fullpath'));

addpath([cvdb_base_path '/ins']);
addpath([cvdb_base_path '/upd']);
addpath([cvdb_base_path '/sel']);
addpath([cvdb_base_path '/util']);
addpath([cvdb_base_path '/serialization']);

javaaddpath([cvdb_base_path '/vendor/mysql-connector/mysql-connector-' ...
             'java-5.1.14-bin.jar']);
javaaddpath([cvdb_base_path '/vendor/mysql-connector']);