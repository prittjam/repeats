function im = get_image(filename);
	sql = sqldb;
	sql.open();
	hash = get_hash(sql,filename);
	db = imagedb;
	is = db.check('image',hash,'raw');
	if is
		s = db.select('image',hash,'raw');
		im = readim(s);
	end
end

function hash = get_hash(sql,name)
    img_set = {};

    stm = sql.connh.prepareStatement(['SELECT COUNT(*) FROM images_hash']);
    rs = stm.executeQuery();
    rs.next();
    count = rs.getInt(1);
    if (count > 0)    
        sql_query = ['SELECT hash ' ...
                     'FROM images_hash ' ...
                     'WHERE name=?'];

        stm = sql.connh.prepareStatement(sql_query);
        stm.setString(1, name); 
        rs = stm.executeQuery();

        hash = {};
        row_num = 0;
        while (rs.next())
            row_num = row_num+1;
            hash(row_num) = rs.getString(1);
        end
    end        
end