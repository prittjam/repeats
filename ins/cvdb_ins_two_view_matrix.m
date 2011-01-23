function [] = cvdb_ins_two_view_matrix(conn, M, matrix_type, ...
                                       img1, img2, ...
                                       rnsc_id, gs_id)

connh = conn.Handle;    

stm = connh.prepareStatement(['INSERT INTO stereo_sets (matrix, type, pair_id, rnsc_id, gs_id)' ...
                    'VALUES(?,?,UNHEX(?),?,?)']);

stm.setBytes(1, typecast(M(:), 'uint8'));
stm.setStirng(2, matrix_type);
stm.setString(3, img_pair_hash);

if isempty(rnsc_id)
    stm.setInt(4, rnsc_id);
else
    stm.setNull(4, java.sql.Types.INTEGER);
end

if (isempty(gs_id))
    stm.setInt(5);
else
    stm.setInt(5, java.sql.Types.INTEGER);
end

stm.execute();