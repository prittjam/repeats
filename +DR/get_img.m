function im = get_img(metadata)
	im = [];
	if isfield(metadata,'cid')
		im = get_image_cass(metadata.cid);
	elseif isfield(metadata,'url')
		im = get_image_cass_url(metadata.url);
	end
	if isempty(im) & isfield(metadata,'url')
		im = get_image_url(metadata.url);
	end	
	im = DR.img(im);
end

function im = get_image_cass(hash);
	db = imagedb;
	is = db.check('image',hash,'raw');
    im = [];
	if is
		s = db.select('image',hash,'raw');
		im = readim(s);
	end
end

function im = get_image_cass_url(url);
	sql = sqldb;
    sql.open();
    [~,name,~] = fileparts(url);
    hash = lower(sql.sel_row('HEX(id)',name));
	db = imagedb;
	is = db.check('image',hash,'raw');
    im = [];
	if is
		s = db.select('image',hash,'raw');
		im = readim(s);
	end
end

function im = get_image_url(url);
	im = imread(url);
end