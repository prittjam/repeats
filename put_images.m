function put_images()
	srcdir = '~/src/gtrepeat/cvpr15/*.*';

	if (exist('skipped.txt', 'file') && ~makesure('File skipped.txt for skipped files already exist. You have done this before. If you proceed, the file will be deleted. Are you sure?', false))
		return;
	end
	delete('skipped.txt');

	somethingSkipped = false;
	fprintf('Reading source direcotries... '); tic;
	l = rdir(srcdir); done; %see help rdir ford correct syntax

	if (numel(l) == 0)
		warning('There is no image, input parameter has to be same as for ''dir'' function');
		return;
	end
	fprintf('Found %d images.\n', numel(l));

	sql = sqldb;
	sql.open();
	create_db(sql);

	db = imagedb;

	progressbar('all', 0);
	n = 0;
	temp = l';
	for i = 1:numel(temp)
		f = temp(i);
		somethingPrinted = false;
		n = n + 1;
		[pathstr, name, ext] = fileparts(f.name);
		fullname = f.name;
		filename = [name, ext];
		switch (filename)
		case {'skipped.txt', '.', '..'}
			continue;
		end

		try
			if ~check_img(sql,filename)
				fullname
				filecontent = getimage(fullname);
				h = hash(filecontent, 'MD5');
				db.insert('image',h,'raw',filecontent);
				ins_hash(sql,filename,h);
			end
			fprintf('c'); somethingPrinted = true;
		
			if ~somethingPrinted;
				fprintf('.');
			end

		catch exception
			msg = exception.message;
			somethingSkipped = true;
			fprintf('s');

			skippedfile = fopen('skipped.txt', 'a');
			fprintf(skippedfile, '%s\t%s\n', fullname, msg);
			fclose(skippedfile);
		end

		progressbar('all', n/numel(l));
	end

	if (somethingSkipped)
		fprintf('Some files were skipped. To see them look into skipped.txt\nThis is head of that file:\n');
		unix('head skipped.txt');
	end
end

function filecontent = getimage(fullname)
	[fpath fname fext] = fileparts(fullname);
	switch (fext)
	case {'.jpg', '.png', '.gif', '.JPG', ''}
	otherwise
		error('Unsuporrted extension.');
	end

	try
		img = imread(fullname);
	catch
		error('Not an image (according to matlab).');
	end

	filecontent = fileread(fullname, inf, '*uint8');
end

function [] = create_db(sqldb)
    stm = sqldb.connh.prepareStatement(['CREATE TABLE IF NOT EXISTS images_hash(' ...
    					'name TEXT NOT NULL, ' ...
                        'hash TEXT NOT NULL)']);
    stm.execute();
end

function ins_hash(sqldb, img_name, hash)
	stm =  sqldb.connh.prepareStatement(['REPLACE INTO images_hash' ...
                        ' (name, hash)' ...
                        ' VALUES(?,?)']);
            
    stm.setString(1, img_name);
    stm.setString(2, hash);
    stm.execute();
end

function upd_hash(sqldb, img_name, hash)
	stm =  this.connh.prepareStatement(['UPDATE imgs' ...
    					' SET name = ?, hash = ?']);
    
    stm.setString(1, img_name);
    stm.setString(2, hash);
    stm.execute();
end

function check = check_img(sqldb,img_name)
	stm =  sqldb.connh.prepareStatement(['SELECT hash ' ...
		                     'FROM images_hash ' ...
		                     'WHERE name=?']);
	stm.setString(1, img_name);
	rs = stm.executeQuery();
	check = rs.next();
end