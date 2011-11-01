function [] = cvdb_connect(server_name, db_name, user_name, password)
global conn;
conn.Handle = cvdb_open(server_name, db_name, user_name, password);