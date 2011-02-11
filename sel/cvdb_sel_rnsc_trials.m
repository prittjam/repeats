function [sample_set, scores] = cvdb_sel_rnsc_trials(conn, ...
                                                     rnsc_id)
connh = conn.Handle;

scores = [];
sample_set = [];

sql_query = ['SELECT sample_set, score FROM ' ...
             'rnsc_trials ' ...
             'WHERE rnsc_id=?'];

stm = connh.prepareStatement(sql_query);
stm.setInt(1, rnsc_id); 
rs = stm.executeQuery();

row_num = 0;
while (rs.next())
    row_num = row_num+1;
    sample_set(row_num,:) = reshape(typecast(rs.getBytes(1), 'double'), 1, []);
    scores(row_num) = rs.getDouble(2);
end