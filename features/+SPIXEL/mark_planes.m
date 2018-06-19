function bimg = mark_planes(img,linfs_segments)
method = 'shadow';
l3 = linfs_segments(:,:,[1 1 1]);
offset = size(img.data,1)*size(img.data,2);

switch(method)
	case 'colors'
		bimg = img.data;
		bimg(l3 == 0) = bimg(l3 == 0)*0.3;
		bimg(linfs_segments == 1) = bimg(linfs_segments == 1)*2;
		bimg(find(linfs_segments == 2)+offset) = bimg(find(linfs_segments == 2)+offset)*2;
	case 'shadow'
		se = strel('square',40);
		se0 = strel('square',15);
		G = fspecial('gaussian',[30 30],20);
		background = (linfs_segments == 0).*0.3;
		dlinfs = zeros(size(background));
		for i = 1:max(linfs_segments(:))
			linf = linfs_segments == i;
			dlinf = imdilate(linf,se);
			dlinf0 = imdilate(linf,se0);
			background = background.*imfilter(1-dlinf0,G,'same');
			background(linf) = 1;
			dlinfs = dlinfs | dlinf;
		end
		background(linfs_segments == 0 & ~dlinfs) = 0.3;
		bimg = uint8(double(img.data).*background(:,:,[1 1 1]));
end