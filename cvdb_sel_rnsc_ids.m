function rnsc_ids =  cvdb_sel_rnsc_ids(conn,  exp_ids, model_fn)

    connh = conn.Handle;

    rnsc_ids = [];

    sql_query = [ ...
        'SELECT rnsc.id FROM ' ...
        'rnsc ' ...
        'INNER JOIN rnsc_cfgs ' ...
        'ON rnsc.cfg_id=rnsc_cfgs.id ' ...
        'WHERE model_fn=?' ...
                ];

    stm = connh.prepareStatement(sql_query);
    stm.setString(1, model_fn);

    rs = stm.executeQuery();

    row_num = 1;
    while rs.next()
        rnsc_ids(row_num) = rs.getInt(1);
        row_num = row_num+1;
    end