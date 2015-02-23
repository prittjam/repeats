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