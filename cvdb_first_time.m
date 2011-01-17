function [] = cvdb_first_time(conn)
    cvdb_clear(conn);
    cvdb_create(conn);
