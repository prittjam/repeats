function im = get_image(url);
	sql = sqldb;
	sql.open();
	hash = sql.get_img_cid(url);
	db = imagedb;
	is = db.check('image',hash,'raw');
	if is
		s = db.select('image',hash,'raw');
		im = readim(s);
	end
end
