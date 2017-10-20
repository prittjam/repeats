function [] = output_rectification(url,rimg,prefix)
if nargin < 3
    prefix = pwd;
end

[~,file_name,file_ext] = fileparts(url);
if ~isempty(rimg)
    rfile_name = ['rect_' file_name file_ext];
    url = fullfile(prefix,rfile_name);
    imwrite(rimg,url); 
end
