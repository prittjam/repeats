%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function rimg = reflect(img,varargin)
rimg = img(:,end:-1:1,:);