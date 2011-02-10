function two_view_results = cvdb_sel_two_view_gs_results(conn, exp_set_id, title, img1, ...
                                                  img2, type)
connh = conn.Handle;

sql_query = ['SELECT matrix,weights,errors,score FROM ' ...
             'two_view_matrices ' ...
             'INNER JOIN stereo_experiments ' ...
             'ON stereo_experiments.id=two_view_matrices.exp_id ' ...
             'INNER JOIN gs ' ...
             'ON two_view_matrices.exp_id=gs.exp_id ' ...
             'WHERE two_view_matrices.gs_id IS NOT NULL AND ' ...
             'stereo_experiments.title=? AND ' ...
             'stereo_experiments.set_id=?'];

stm = connh.prepareStatement(sql_query);

stm.setString(1, title); 
stm.setInt(2, exp_set_id);

rs = stm.executeQuery();
img_set = {};
row_num = 0;
while (rs.next())
    row_num = row_num+1;
    F = reshape(typecast(rs.getObject(1), 'double'), 3, 3);
    w = reshape(typecast(rs.getObject(2), 'double'), 1, []);
    e = reshape(typecast(rs.getObject(3), 'double'), 1, []);
    s = reshape(typecast(rs.getObject(4), 'double'), 1, []);    
    two_view_results{row_num} = {F, w, e, s};
end