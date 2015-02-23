function filecontent = get_native_img(url)
    [fpath fname fext] = fileparts(url);
    switch (lower(fext))
      case {'.jpg', '.png', '.gif', ''}
      otherwise
        error('Unsuporrted extension.');
    end

    try
        img = imread(url);
    catch
        error('Not an image (according to matlab).');
    end

    filecontent = fileread(url, inf, '*uint8');
end

function res = fileread(fname, count, precision)
%FILEREAD fopen, freed, fclose composite for easy use
%   FILEREAD(fname, count, precision)
%      fname is name of the input file
%      count is optional argument for fread
%      precision is precision for fread function
	error(nargchk(2, 3, nargin));

	fid = fopen(fname, 'r');
	if (fid < 0)
		error('File ''%s'' cannot be read.', fname);
	end

	if nargin == 2
		res = fread(fid, count);
	else
		res = fread(fid, count, precision);
	end
	fclose(fid);
end
