function two_view_results = cvdb_sel_two_view_gs_results(conn, exp_set_id, title, pair_id, type)
connh = conn.Handle;
two_view_results = {};
sql_query = ['SELECT matrix,weights,errors,score FROM ' ...
             'two_view_matrices ' ...
             'INNER JOIN stereo_experiments ' ...
             'ON stereo_experiments.id=two_view_matrices.exp_id ' ...
             'INNER JOIN gs ' ...
             'ON two_view_matrices.exp_id=gs.exp_id ' ...
             'WHERE (two_view_matrices.gs_id IS NOT NULL AND ' ...
             'stereo_experiments.title=?) AND ' ...
             'stereo_experiments.set_id=?'];

stm = connh.prepareStatement(sql_query);

stm.setString(1, title); 
stm.setString(2, exp_set_id);

rs = stm.executeQuery();
img_set = {};
row_num = 0;
while (rs.next())
    row_num = row_num+1;
    M = reshape(typecast(rs.getBytes(1), 'double'), 3, 3);
    w = reshape(typecast(rs.getBytes(2), 'uint8'), 1, []);
    e = reshape(typecast(rs.getBytes(3), 'double'), 1, []);
    s = rs.getDouble(4);    
    two_view_results{row_num} = {M, w, e, s};
end