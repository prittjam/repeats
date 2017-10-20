function [] = output_rectification(img,rimg,ud_img,prefix)
if nargin < 3
    ud_img = [];
end

if nargin < 4
    prefix = pwd;
end

[~,file_name,file_ext] = fileparts(img.url);
if ~isempty(rimg)
    rfile_name = ['rect_' file_name file_ext];
    url = fullfile(prefix,rfile_name);
    imwrite(rimg,url); 
end
if ~isempty(ud_img)
    udfile_name = ['ud_' file_name file_ext];
    url = fullfile(prefix,udfile_name);
    imwrite(ud_img,url);    
end
