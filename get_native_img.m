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
    
function res = fileread(fname, count, precision)
narginchk(2,3);
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
