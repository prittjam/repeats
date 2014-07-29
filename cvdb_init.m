function conn = cvdb_init(wbs_base_path)
x = dbstatus; 
cvdb_addpaths(wbs_base_path);
dbstop(x);
