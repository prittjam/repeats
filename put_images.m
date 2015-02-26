function put_images()
	srcdir = '~/src/gtrepeat/cvpr15';
	name_of_set = 'cvpr15/annotations';

	if (exist('skipped.txt', 'file') && ~makesure('File skipped.txt for skipped files already exist. You have done this before. If you proceed, the file will be deleted. Are you sure?', false))
		return;
	end
	delete('skipped.txt');

	somethingSkipped = false;
	fprintf('Reading source direcotries... '); tic;
	img_urls = get_img_urls(srcdir); done; %see help rdir ford correct syntax

	if (numel(img_urls) == 0)
		warning('There is no image, input parameter has to be same as for ''dir'' function');
		return;
	end
	fprintf('Found %d images.\n', numel(img_urls));

	sql = sqldb;
	sql.open();
	sql.create();

	db = imagedb;

	progressbar('all', 0);
	n = 0;

	cids = sql.ins_img_set(name_of_set,img_urls,...
                   'InsertMode','Replace');
	for i = 1:numel(img_urls)
		url = img_urls{i};
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
				% filecontent = getimage(url);
				% h = hash(filecontent, 'MD5');
				db.insert('image',cids{i},'raw',filecontent);
				% sql.ins_img(h,url);
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

		progressbar('all', n/numel(img_urls));
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

function img_urls = get_img_urls(base_path)
	img_urls = dir(fullfile(base_path,'*.jpg'));
	img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.JPG')));
	img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.png')));
	img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.PNG')));
	img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.gif')));
	img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.GIF')));

	img_urls = rmfield(img_urls,{'date','bytes','isdir','datenum'});
	img_urls = struct2cell(img_urls);
	img_urls = cellfun(@(x)[base_path '/' x],img_urls,'UniformOutput',false);
end