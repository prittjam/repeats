function [] = cvdb_ins_img_set(conn, set_name, img_set_path, ...
                               img_set, varargin)
    p = inputParser;

    p.addParamValue('insertmode','keep',@isstr);
    p.addParamValue('description','',@isstr);
    p.parse(varargin{:});
    if strcmpi(p.Results.insertmode,'keep')
        replace = 0;
    else
        replace = 1;
    end
    
    connh = conn.Handle;
    
    stm = connh.prepareStatement(['SELECT COUNT(*) FROM img_sets ' ...
                        'WHERE name=?']);
    stm.setString(1, set_name);
    rs = stm.executeQuery();
    rs.next();
    count = rs.getInt(1);
    
    if (count == 0 || replace == 1)
        stm = connh.prepareStatement(['REPLACE INTO img_sets ' ...
                            '(name, img_id) ' ...
                            'VALUES (?,UNHEX(?))']);
        
        for i = 1:length(img_set)
            img_path = [img_set_path img_set{i}]
            
            img = imread(img_path);
            h = cvdb_hash_img(img(:));
            sql_statement = ['SELECT COUNT(*) FROM imgs WHERE id=' ...
                             'UNHEX(?)'];
            stm2 = connh.prepareStatement(sql_statement);
            stm2.setString(1, h);
            rs = stm2.executeQuery();
            rs.next();
            count = rs.getInt(1);

            %            if (count == 0)     
                [pth, img_name, ext] = fileparts(img_set{i});
                rel_pth = regexpi(img_path, '[^/]*/[^/]*$', ...
                                  'match');
                cvdb_ins_img(conn, img, ...
                             img_path, rel_pth, img_name, ...
                             ext);
                %            end
            
            sql_statement = ['SELECT COUNT(*) FROM img_sets ' ... 
                             'WHERE name=? AND ' ...
                             'img_id=UNHEX(?)'];
            stm2 = connh.prepareStatement(sql_statement);        
            stm2.setString(1, set_name);
            stm2.setString(2, h);
            rs = stm2.executeQuery();
            rs.next();
            count = rs.getInt(1);
            
            if (count == 0 || replace == 1) 
                stm.setString(1, set_name);
                stm.setString(2, h);
                stm.addBatch();
            end
        end
        err = stm.executeBatch();
    end
    close(stm);