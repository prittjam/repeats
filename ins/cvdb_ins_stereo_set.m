function [] = cvdb_ins_stereo_set(conn, set_name, img_set_path, ...
                                  img_set, description)
    error(nargchk(4,5,nargin));

    if nargin < 5
        description = [];
    end
    
    connh = conn.Handle;
    h = char(zeros(2,64));
    
    stm = connh.prepareStatement(['SELECT COUNT(*) FROM stereo_sets ' ...
                        'WHERE name=?']);
    stm.setString(1, set_name);
    rs = stm.executeQuery();
    rs.next();
    count = rs.getInt(1);
    
    if (count == 0)
        for i = 1:length(img_set)
            img_path_pair = ...
                { ...
                    [img_set_path img_set{i}{1}], ...
                    [img_set_path img_set{i}{2}] ...
                };
            
            for j = 1:2
                [pth, img_name, ext] = fileparts(img_path_pair{j});
                img{j} = imread(img_path_pair{j});
                width  = size(img{j},2);
                height = size(img{j},1);

                sql_statement = ['SELECT COUNT(*) FROM imgs WHERE id=' ...
                                 'UNHEX(?)'];
                stm = connh.prepareStatement(sql_statement);
                h(j,:) = cvdb_hash_img(img{j}(:));
                
                stm.setString(1, h(j,:));
                rs = stm.executeQuery();
                rs.next();
                count = rs.getInt(1);
                rel_pth = regexpi(img_path_pair{j}, '[^/]*/[^/]*$', ...
                                  'match');
                if (count == 0) 
                    cvdb_ins_img(conn, img{j}, ...
                                img_path_pair{j}, rel_pth, img_name, ext);
                end
            end
            xorh = cvdb_img_hash_xor(h(1,:), ...
                                     h(2,:));

            sql_statement = ['SELECT COUNT(*) FROM img_pairs WHERE ' ...
                             'id=UNHEX(?)'];

            stm = connh.prepareStatement(sql_statement);
            stm.setString(1, xorh);
            rs = stm.executeQuery();
            rs.next();
            count = rs.getInt(1);
            if (count == 0) 
                stm = connh.prepareStatement(['INSERT INTO img_pairs (id, img1_id, img2_id)' ...
                                    'VALUES(UNHEX(?),UNHEX(?),UNHEX(?))']);
                stm.setString(1, xorh);
                stm.setString(2, h(1,:));
                stm.setString(3, h(2,:));
                err = stm.execute();
            end
            
            sql_statement = ['SELECT COUNT(*) FROM stereo_sets WHERE ' ...
                             'pair_id=UNHEX(?)'];
            stm = connh.prepareStatement(sql_statement);
            xorh = cvdb_img_hash_xor(h(1,:), ...
                                     h(2,:));
            stm.setString(1, cvdb_stringify_hash(xorh));
            rs = stm.executeQuery();
            rs.next();
            count = rs.getInt(1);
            if (count == 0) 
                stm = connh.prepareStatement(['INSERT INTO stereo_sets (name,pair_id,description)' ...
                                    'VALUES(?,UNHEX(?),?)']);
                stm.setString(1, set_name);
                stm.setString(2, xorh);
                if isempty(description)
                    stm.setNull(3, java.sql.Types.VARCHAR);
                else
                    stm.setString(3, description);
                end

                err = stm.execute();
            end
        end
    end