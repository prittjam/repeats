function [exp_id, set_id] = cvdb_find_closest_experiment(user, begin_time)
    sql_query = [ ...
        'SELECT id,set_id,begin' ...
        'FROM stereo_experiments ' ...
        'WHERE user=?  ' ...
        'ORDER BY abs(?-begin) LIMIT 1' ...
                ];
    stm = connh.prepareStatement(sql_query);
    stm.setString(1, user);
    stm.setTimestamp(2, begin_time);
    
    rs = stm.executeQuery();

    if rs.next()
        id = rs.getInt(1);
        set_id = rs.getInt(2);
    end