function [M,matrix_type] = cvdb_sel_two_view_matrix(conn, ...
                                                    img1, img2, ...
                                                    rnsc_id, gs_id)
    connh = conn.Handle;

    pair_hash = cvdb_hash_img_pair(img1, img2);
    
    if (~isempty(rnsc_id))
        sql_query = [ ...
            'SELECT matrix,type ' ...
            'FROM two_view_matrices ' ...
            'WHERE rnsc_id=?' ...
                    ];
        stm = connh.prepareStatement(sql_query);
        stm.setInt(1, rnsc_id);
    else
        sql_query = [ ...
            'SELECT matrix,type ' ...
            'FROM two_view_matrices ' ...
            'WHERE gs_id=?' ...
                    ];
        stm = connh.prepareStatement(sql_query);
        stm.setInt(1, gs_id);
    end
    
    rs = stm.executeQuery();
    
    M = [];
    matrix_type = [];
    
    if rs.next()
        M = reshape(typecast(rs.getBinary(1), 'double'), 3, 3);
        matrix_type = char(rs.getString(2));
    end
