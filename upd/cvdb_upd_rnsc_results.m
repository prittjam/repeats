function auto_id = cvdb_upd_rnsc_results(conn, rnsc_id, res, ...
                                         tag_list)
    
    connh = conn.Handle;

    if nargin < 4
        tag_list = {};
    end

    stm = connh.prepareStatement(['UPDATE rnsc ' ...
                        'SET weights=?, errors=?, score=?, ' ...
                        'samples_drawn=?, sample_degen_count=?, ' ...
                        'us_time_elapsed=? WHERE id=?']);
    
    stm.setBytes(1, typecast(double(res.weights(:)), 'uint8'));
    stm.setBytes(2, typecast(res.errors(:), 'uint8'));
    stm.setDouble(3, res.score);
    stm.setInt(4, res.samples_drawn);
    stm.setInt(5, res.sample_degen_count);    
    stm.setInt(6, res.us_time_elapsed);    
    stm.setInt(7, rnsc_id);

    stm.execute();

    if (~isempty(tag_list))
        cvdb_ins_rnsc_taggings(conn, tag_list, rnsc_id);
    end
