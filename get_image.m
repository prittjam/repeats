function im = get_image(url);
	sql = sqldb;
	sql.open();
	cid = sql.get_img_cid(url);
	db = imagedb;
	is = db.check('image',cid,'raw');
	if is
		s = db.select('image',cid,'raw');
		[~,~,ext] = fileparts(url);
		if ext == '.png' || '.PNG'
			
		else
			im = readim(s);
		end
	end
end
