classdef sqldb < sqlbase
    methods(Access=public)
        function this = sqldb(varargin)
            this@sqlbase(varargin{:});
        end

        function h = ins_img(this, img, ...
                             absolute_path, rel_pth, img_name, ...
                             ext)
            h = cvdb_hash_img(img(:));
            width  = size(img,2);
            height = size(img,1);
            
            stm =  this.connh.prepareStatement(['REPLACE INTO imgs ' ...
                                'VALUES(UNHEX(?),?,?,?,?,?,?)']);
            stm.setString(1, h);
            stm.setString(2, absolute_path);
            stm.setString(3, rel_pth);
            stm.setString(4, img_name);
            stm.setString(5, ext);
            stm.setInt(6, height);
            stm.setInt(7, width);
    
            err = stm.execute();
        end        

        function hh = ins_img_set(this,set_name, ...
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

            stm = this.connh.prepareStatement(['SELECT COUNT(*) FROM img_sets ' ...
                                'WHERE name=?']);
            stm.setString(1, set_name);
            rs = stm.executeQuery();
            rs.next();
            count = rs.getInt(1);
            
            if (count == 0 || replace == 1)
                stm = this.connh.prepareStatement(['REPLACE INTO img_sets ' ...
                                    '(name, img_id) ' ...
                                    'VALUES (?,UNHEX(?))']);
                hh = {};
                for i = 1:length(img_set)
                    img_path = img_set{i}
                    
                    img = imread(img_path);
                    h = cvdb_hash_img(img(:));
                    sql_statement = ['SELECT COUNT(*) FROM imgs WHERE id=' ...
                                     'UNHEX(?)'];
                    stm2 = this.connh.prepareStatement(sql_statement);
                    stm2.setString(1, h);
                    rs = stm2.executeQuery();
                    rs.next();
                    count = rs.getInt(1);

                    %            if (count == 0)     
                    [pth, img_name, ext] = fileparts(img_set{i});
                    rel_pth = regexpi(img_path, '[^/]*/[^/]*$', ...
                                      'match');
                    hh{i} = this.ins_img(img, img_path, rel_pth, ...
                                        img_name, ext);
                    %            end
                    
                    sql_statement = ['SELECT COUNT(*) FROM img_sets ' ... 
                                     'WHERE name=? AND ' ...
                                     'img_id=UNHEX(?)'];
                    stm2 = this.connh.prepareStatement(sql_statement);        
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
        end    

        function img_set = sel_img_set(this, set_name)
            img_set = {};

            stm = this.connh.prepareStatement(['SELECT COUNT(*) FROM img_sets ' ...
                                'WHERE name=?']);
            stm.setString(1, set_name);
            rs = stm.executeQuery();
            rs.next();
            count = rs.getInt(1);

            if (count > 0)    
                sql_query = ['SELECT url,height,width ' ...
                             'FROM img_sets JOIN imgs ' ...
                             'WHERE img_sets.img_id=imgs.id ' ...
                             'AND img_sets.name=?'];

                stm = this.connh.prepareStatement(sql_query);
                stm.setString(1, set_name); 
                rs = stm.executeQuery();

                img_set = {};
                row_num = 0;
                while (rs.next())
                    row_num = row_num+1;

                    img_set(row_num).url = char(rs.getString(1));
                    img_set(row_num).height = rs.getInt(2);
                    img_set(row_num).width = rs.getInt(3);
                    img_set(row_num).cc = ...
                        [ (img_set(row_num).width+1)/2; ...
                          (img_set(row_num).height+1)/2 ];
                end
            end        
        end
    end
end