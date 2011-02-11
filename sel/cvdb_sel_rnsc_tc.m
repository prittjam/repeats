function tc = cvdb_sel_rnsc_tc(conn, rnsc_id)
    connh = conn.Handle;

    tc = [];

    sql_query = ['SELECT DISTINCT count, type, data ' ...
                 'FROM rnsc ' ...
                 'INNER JOIN stereo_experiments ' ...
                 'ON stereo_experiments.id=rnsc.exp_id ' ...
                 'INNER JOIN tc ' ...
                 'ON tc.cfg_id=rnsc.tc_id AND ' ...
                 'tc.pair_id=stereo_experiments.pair_id ' ...
                 'WHERE rnsc.id=?'];
    
    stm = connh.prepareStatement(sql_query);
    stm.setInt(1, rnsc_id);
    
    rs = stm.executeQuery();

    row_num = 0;
    while (rs.next())
        row_num = row_num+1;

        count = rs.getInt(1);
        tc_type = char(rs.getString(2));
        switch tc_type
          case 'LAF'
            tc = reshape(typecast(rs.getBytes(3), 'double'), 18, ...
                         count);
%            sample_set = reshape(typecast(rs.getObject(4), 'double'), 1, ...
%                                 count);
        end
    end