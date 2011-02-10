function conn2 = cvdb_open(server_name, db_name, user_name, password)
    import com.mysql.jdbc.*;
    import MySQLLoader;

    try
        conn = MySQLLoader.makeConnection('nash.felk.cvut.cz', db_name, user_name, ...
                                          password);
    catch exception
        throw(MException('MySQLDatabase:mysqlError', ...
                         char(exception.message)));
    end
    conn2.Handle = conn;
%    jdbc_string = sprintf('jdbc:mysql://%s/%s', server_name, db_name);
%    jdbc_driver = 'com.mysql.jdbc.Driver';
%n = database(db_name, user_name, password, ...
%             jdbc_driver, jdbc_string);
%~isconnection(conn)
% warning('Cannot connect to Database.');
%