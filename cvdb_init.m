function [conn] = cvdb_init(server_name, db_name, user_name, password)
    base_path = fileparts(which('cvdb_init'));
    
    addpath([base_path '/ins']);
    addpath([base_path '/sel']);
    addpath([base_path '/del']);
    addpath([base_path '/upd']);
    addpath([base_path '/util']);
    addpath([base_path '/serialization']);
    addpath([base_path '/serialization/json']);
    
    javaaddpath([base_path '/mysql-connector/mysql-connector-' ...
                 'java-5.1.14-bin.jar']);
    
    conn = cvdb_open(server_name, db_name, user_name, password);