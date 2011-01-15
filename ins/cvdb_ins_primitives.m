function auto_id = cvdb_ins_primitives(conn, X, ...
                                       img, name, tag_list)
    error(nargchk(3, 5, nargin));
    
    if (nargin < 4)
        name = {};
    end
    
    if (nargin < 5)
        tag_list = {};
    end

    connh = conn.Handle;
    h = cvdb_hash_img(img);
    stm =  connh.prepareStatement(['INSERT INTO primitives (data, img_id, name) ' ...
                        'VALUES (?,UNHEX(?),?)'], java.sql.Statement.RETURN_GENERATED_KEYS);

    stm.setObject(1, X);
    stm.setString(2, h);
    if (~isempty(name))
        stm.setString(3, name);
    else
        stm.setNull(3, java.sql.Types.VARCHAR);
    end
    stm.addBatch();
    
    stm.executeBatch();

    rs = stm.getGeneratedKeys()
    primitive_key_list = zeros(1, length(X));      
    
    while (rs.next())
        auto_id = rs.getInt(1);
        if (~isempty(tag_list))
            cvdb_ins_geometry_taggings(conn, tag_list, auto_id);
        end
    end
    
    close(stm);