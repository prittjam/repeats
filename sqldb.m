classdef sqldb < sqlbase
    methods(Access=public)
        function this = sqldb(varargin)
            this@sqlbase(varargin{:});
        end

        function [] = create()
            stm = this.connh.prepareStatement(['CREATE TABLE IF NOT EXISTS imgs(' ...
                                'id BINARY(16), ' ...
                                'url TEXT, ' ...
                                'name TEXT NOT NULL, ' ...
                                'ext TEXT NOT NULL, ' ...
                                'height INTEGER NOT NULL, ' ...
                                'width INTEGER NOT NULL, ' ...
                                'PRIMARY KEY(id))']);
            stm.execute();

            stm = this.connh.prepareStatement(['CREATE TABLE IF NOT EXISTS img_sets(' ...
                                'id INTEGER AUTO_INCREMENT, ' ...
                                'name VARCHAR(128) NOT NULL, ' ...
                                'img_id BINARY(16) NOT NULL, ' ...
                                'description TEXT, ' ...
                                'PRIMARY KEY(id), ' ...
                                'INDEX(name), ' ...
                                'CONSTRAINT img_set_id UNIQUE (name,img_id),' ...
                                'CONSTRAINT FOREIGN KEY(img_id) REFERENCES imgs(id))']);
            stm.execute();
    
            stm = this.connh.prepareStatement(['CREATE TABLE IF NOT EXISTS stereo_sets(' ...
                                'id INTEGER AUTO_INCREMENT, ', ...
                                'name VARCHAR(256) NOT NULL, ' ...
                                'img1_id BINARY(16) NOT NULL, ' ...
                                'img2_id BINARY(16) NOT NULL, ' ...
                                'gt_url TEXT, ' ...
                                'description TEXT, ' ...
                                'acknowledgement TEXT, ' ...
                                'refs TEXT, ' ...
                                'PRIMARY KEY(id), ' ...
                                'INDEX(name), ' ...
                                'CONSTRAINT stereo_set_id UNIQUE (name,img1_id,img2_id), ' ...
                                'CONSTRAINT FOREIGN KEY(img1_id,img2_id) ' ...
                                'REFERENCES img_pairs(img1_id,img2_id))']);
            stm.execute();
        end

        function [] =  clear(conn)
            warning('sqldb just erased all the cvdb tables in your database');
            stm = this.connh.prepareStatement(['DROP TABLE IF EXISTS imgs, img_pairs, ' ...
                                'stereo_sets, rnsc, rnsc_cfgs, ' ...
                                'stereo_experiments, ' ...
                                'img_sets, tags, stereo_taggings, primitives, ' ...
                                'geometry_taggings, calib_data, calib_results, ' ...
                                'rnsc_taggings, detector_cfgs, detectors, descriptor_cfgs, ' ...
                                'descriptors,  tc_cfgs,  tc, two_view_matrices, ' ...
                                'gs, gs_cfgs, rnsc_primitives, rnsc_trials']);
            stm.execute();
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
            cfg = [];
            cfg.description = [];
            cfg.replace = true;
            [cfg,leftover] =  helpers.vl_argparse(cfg,varargin{:});

            stm = this.connh.prepareStatement(['SELECT COUNT(*) FROM img_sets ' ...
                                'WHERE name=?']);
            stm.setString(1, set_name);
            rs = stm.executeQuery();
            rs.next();
            count = rs.getInt(1);
            
            if (count == 0 || cfg.replace)
                stm = this.connh.prepareStatement(['REPLACE INTO img_sets ' ...
                                    '(name, img_id) ' ...
                                    'VALUES (?,UNHEX(?))']);
                hh = {};
                for i = 1:length(img_set)
                    img_path = img_set{i};
                    
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
                    
                    if (count == 0 || cfg.replace) 
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


        function [] = ins_stereo_set(this,set_name,img_set,varargin)
            cfg = [];
            cfg.description = [];
            cfg.replace = false;

            [cfg,leftover] =  helpers.vl_argparse(cfg,varargin{:});
 
            h = char(zeros(2,32));

            stm = this.connh.prepareStatement(['SELECT COUNT(*) FROM stereo_sets ' ...
                                'WHERE name=?']);
            stm.setString(1, set_name);
            rs = stm.executeQuery();
            rs.next();
            count = rs.getInt(1);

            if (count == 0 || cfg.replace == 1)
                for i = 1:length(img_set)
                    for j = 1:2
                        [pth, img_name, ext] = fileparts(img_set{i}{j});
                        img{j} = imread(img_set{i}{j});
                        width  = size(img{j},2);
                        height = size(img{j},1);

                        sql_statement = ['SELECT COUNT(*) FROM imgs WHERE id=' ...
                                         'UNHEX(?)'];
                        stm = this.connh.prepareStatement(sql_statement);
                        h(j,:) = cvdb_hash_img(img{j}(:));
                        
                        stm.setString(1, h(j,:));
                        rs = stm.executeQuery();
                        rs.next();
                        count = rs.getInt(1);
                        rel_pth = regexpi(img_set{i}{j}, '[^/]*/[^/]*$', ...
                                          'match');
                        if (count == 0) 
                            cvdb_ins_img(conn, img{j}, ...
                                         img_path_pair{j}, rel_pth, img_name, ext);
                        end
                    end
                    
                    sql_statement = ['SELECT COUNT(*) FROM stereo_sets WHERE ' ...
                                     'img1_id=UNHEX(?) AND img2_id=UNHEX(?)'];
                    stm = this.connh.prepareStatement(sql_statement);
                    stm.setString(1,h(1,:));
                    stm.setString(2,h(2,:));
                    rs = stm.executeQuery();
                    rs.next();
                    count = rs.getInt(1);
                    if (count == 0 || cfg.replace)
                        stm = this.connh.prepareStatement(['REPLACE INTO stereo_sets (name,img1_id,img2_id,gt_url,description)' ...
                                            'VALUES(?,UNHEX(?),UNHEX(?),?,?)']);
                        stm.setString(1,set_name);
                        stm.setString(2,h(1,:));
                        stm.setString(3,h(2,:));

                        if (numel(img_set{i}) > 2)
                            stm.setString(4,[img_set{i}{3}]); 
                        else
                            stm.setNull(4,java.sql.Types.VARCHAR);                
                        end

                        if isempty(cfg.description)
                            stm.setNull(5,java.sql.Types.VARCHAR);
                        else
                            stm.setString(5,cfg.description);
                        end

                        err = stm.execute();
                    end
                end
            end
        end

        function stereo_set = sel_stereo_set(this,set_name)
            stereo_set = {};
            stm = this.connh.prepareStatement(['SELECT COUNT(*) FROM stereo_sets ' ...
                                'WHERE name=?']);
            stm.setString(1, set_name);
            rs = stm.executeQuery();
            rs.next();
            count = rs.getInt(1);

            if (count > 0)    
                img_num = 'img1_id';

                sql_query_1 = ['SELECT im1.url, im1.height, im1.width, im1.name, im1.ext, ' ...
                               'im2.url, im2.height, im2.width, im2.name, im1.ext, ss.gt_url ' ...
                               'FROM stereo_sets AS ss ' ...
                               'INNER JOIN imgs AS im1 ON img1_id = im1.id ' ...
                               'INNER JOIN imgs AS im2 ON img2_id = im2.id ' ...
                               'WHERE ss.name = ?'];

                stm = this.connh.prepareStatement(sql_query_1);
                stm.setString(1, set_name);
                rs = stm.executeQuery();

                stereo_set = {};
                row_num = 0;
                while (rs.next())
                    row_num = row_num+1;

                    stereo_set(row_num).img1.url = ...
                        char(rs.getString(1));
                    stereo_set(row_num).img1.height = ...
                        rs.getInt(2);
                    stereo_set(row_num).img1.width = ...
                        rs.getInt(3);
                    stereo_set(row_num).img1.name = ...
                        char(rs.getString(4));
                    stereo_set(row_num).img1.ext = ...
                        char(rs.getString(5));

                    names_lower{row_num} = lower(stereo_set(row_num).img1.name);

                    stereo_set(row_num).img2.url = ...
                        char(rs.getString(6));
                    stereo_set(row_num).img2.height = ...
                        rs.getInt(7);
                    stereo_set(row_num).img2.width = ...
                        rs.getInt(8);
                    stereo_set(row_num).img2.name = ...
                        char(rs.getString(9));
                    stereo_set(row_num).img2.ext = ...
                        char(rs.getString(10));

                    stereo_set(row_num).gt_url = ...
                        char(rs.getString(11));
                end
            end

            [~,ind] = sort(names_lower);
            stereo_set = stereo_set(ind);
        end
    end

end