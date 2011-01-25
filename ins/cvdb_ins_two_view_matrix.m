function [] = cvdb_ins_two_view_matrix(conn, M, matrix_type, ...
                                       exp_id, ...
                                       pair_id, ...
                                       rnsc_id, ...
                                       gs_id)
    connh = conn.Handle;    

    stm = connh.prepareStatement(['INSERT INTO two_view_matrices (matrix, type, exp_id, pair_id, rnsc_id, gs_id)' ...
                        'VALUES(?,?,?,UNHEX(?),?,?)']);

    stm.setBytes(1, typecast(M(:), 'uint8'));
    stm.setString(2, matrix_type);
    stm.setInt(3, exp_id);
    stm.setString(4, pair_id);

    if isempty(rnsc_id)
        stm.setNull(5, java.sql.Types.INTEGER);
    else
        stm.setInt(5, rnsc_id);
    end
    
    if (isempty(gs_id))
        stm.setNull(6, java.sql.Types.INTEGER);
    else
        stm.setInt(6, gs_id);
    end

    stm.execute();