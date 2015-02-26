function put_images()
	srcdir = '~/src/gtrepeat/cvpr15/*.*';
	name_of_set = 'cvpr15/annotations';

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
	sql.create();

	db = imagedb;

	progressbar('all', 0);
	n = 0;
	imgs = l';
	imgs = {imgs(:).name};
	for i = 1:numel(imgs)
		url = imgs{i};
		somethingPrinted = false;
		n = n + 1;
		[pathstr, name, ext] = fileparts(url);
		filename = [name, ext];
		switch (filename)
		case {'skipped.txt', '.', '..'}
			continue;
		end

		try
			if ~sql.check_img(url)
				filecontent = getimage(url);
				h = hash(filecontent, 'MD5');
				db.insert('image',h,'raw',filecontent);
				sql.ins_img(h,url);
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
			fprintf(skippedfile, '%s\t%s\n', url, msg);
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
