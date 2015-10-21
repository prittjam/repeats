function [] = make_sqldb()
sql = SQL.SqlDb;
sql.open();
sql.clear();
sql.create();