function [rnsc_cfg_exist, h] = cvdb_sel_rnsc_cfg_exist(conn, rnsc_cfg, ...
                                                      h)
    connh = conn.Handle;

    if nargin < 3
        h = cfg2hash(rnsc_cfg);
    end

    sql_statement = ['SELECT COUNT(*) FROM rnsc_cfgs WHERE id=' ...
                     'UNHEX(?)'];
    stm = connh.prepareStatement(sql_statement);
    stm.setString(1, h);
    rs = stm.executeQuery();
    rs.next();
    rnsc_cfg_exist = rs.getInt(1);

