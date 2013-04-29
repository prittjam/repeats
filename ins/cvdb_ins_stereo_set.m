function [] = cvdb_ins_stereo_set(conn, set_name,img_set_path, ...
                                  img_set,varargin)
p = inputParser;

p.addParamValue('InsertMode','Keep',@isstr);
p.addParamValue('Description','',@isstr);
p.parse(varargin{:});

if strcmpi(p.Results.InsertMode,'Replace')
    replace = 1;
else
    replace = 0;
end

description = p.Results.Description;

connh = conn.Handle;

h = char(zeros(2,32));

stm = connh.prepareStatement(['SELECT COUNT(*) FROM stereo_sets ' ...
                    'WHERE name=?']);
stm.setString(1, set_name);
rs = stm.executeQuery();
rs.next();
count = rs.getInt(1);

if (count == 0 || replace == 1)
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
        
        sql_statement = ['SELECT COUNT(*) FROM stereo_sets WHERE ' ...
                         'img1_id=UNHEX(?) AND img2_id=UNHEX(?)'];
        stm = connh.prepareStatement(sql_statement);
        stm.setString(1,h(1,:));
        stm.setString(2,h(2,:));
        rs = stm.executeQuery();
        rs.next();
        count = rs.getInt(1);
        if (count == 0 || replace == 1)
            stm = connh.prepareStatement(['REPLACE INTO stereo_sets (name,img1_id,img2_id,gt_url,description)' ...
                                'VALUES(?,UNHEX(?),UNHEX(?),?,?)']);
            stm.setString(1,set_name);
            stm.setString(2,h(1,:));
            stm.setString(3,h(2,:));

            if (numel(img_set{i}) > 2)
                stm.setString(4,[img_set_path img_set{i}{3}]); 
            else
                stm.setNull(4,java.sql.Types.VARCHAR);                
            end

            if isempty(description)
                stm.setNull(5,java.sql.Types.VARCHAR);
            else
                stm.setString(5,description);
            end

            err = stm.execute();
        end
    end
end