function [set_id] = cvdb_find_closest_experiment(conn, ...
                                                 user, begin_time)
    connh = conn.Handle;

    exp_id = -1;
    set_id = -1;
    sql_query = [ ...
        'SELECT id, set_id, begin ' ...
        'FROM stereo_experiments ' ...
        'WHERE user=?  ' ...
        'ORDER BY abs(?-begin) LIMIT 1' ...
                ];
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, user);

    sqlDate = java.sql.Timestamp(java.util.Date().getTime());
    stm.setTimestamp(2, sqlDate);
    
    rs = stm.executeQuery();

    if rs.next()
        exp_id = rs.getInt(1);
        set_id = char(rs.getString(2))
    end