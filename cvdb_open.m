function [conn] = cvdb_open(server_name, db_name, user_name, password)
    global conn;
    jdbc_string = sprintf('jdbc:mysql://%s/%s', server_name, db_name);
    jdbc_driver = 'com.mysql.jdbc.Driver';
    conn = database(db_name, user_name, password, ...
                    jdbc_driver, jdbc_string);
    if ~isconnection(conn)
        warning('Cannot connect to Database.');
    end