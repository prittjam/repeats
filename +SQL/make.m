function [] = make_sqldb()
sql = sqldb;
sql.open();
sql.clear();
sql.create();