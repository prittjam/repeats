%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
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
