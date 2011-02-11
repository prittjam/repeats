function [exp_set_id, exp_ids] = cvdb_find_closest_experiment_set(conn, ...
                                                      user, begin_time, ...
                                                      title)
    connh = conn.Handle;

    exp_ids = [];

    sql_query = [ ...
        'SELECT set_id, begin ' ...
        'FROM stereo_experiments ' ...
        'WHERE user=?  AND ' ...
        'title=? ' ...
        'ORDER BY abs(?-begin) DESC LIMIT 1' ...
                ];
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, user);

    sqlDate = java.sql.Timestamp(java.util.Date().getTime());
    stm.setString(2, title);
    stm.setTimestamp(3, sqlDate);

    rs = stm.executeQuery();

    row_num = 1;
    while rs.next()
        exp_set_id = char(rs.getString(1));
    end

    sql_query = [ ...
        'SELECT id ' ...
        'FROM stereo_experiments ' ...
        'WHERE set_id=?'];
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, exp_set_id);

    rs = stm.executeQuery();

    row_num = 1;
    while rs.next()
        exp_ids(row_num) = rs.getInt(1);
        row_num = row_num+1;
    end

