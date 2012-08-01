function conn2 = cvdb_open(server_name, db_name, user_name, password)
connh = [];
try
    [conn connh] = dbconn(db_name, user_name,  password);
catch exception
    warning(['Could not open database connection. Database will be ' ...
             'unavailable']);
end

conn2.Handle = connh;