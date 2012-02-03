function conn2 = cvdb_open(server_name, db_name, user_name, password)
try
    [conn connh] = dbconn(db_name, user_name,  password);
catch exception
    throw(MException('MySQLDatabase:mysqlError', ...
                     char(exception.message)));
end

conn2.Handle = connh;