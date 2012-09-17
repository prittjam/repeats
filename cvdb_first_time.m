function [] = cvdb_first_time()
    cvdb_init('../../../wbs');
    global conn;

    cvdb_clear(conn);
    cvdb_create(conn);
