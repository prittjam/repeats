%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [model_list,lo_res_list,stats_list,meas,img] = ...
    do_one_img(img_url,solver,varargin)
repeats_init();
dbpath = fileparts(mfilename('fullpath'));
KeyValDb.getObj('dbfile', [dbpath '/features.db']); 
img = Img('url', img_url);  
cache_params = { 'read_cache', true, ...
                 'write_cache', true };
cid_cache = CidCache(img.cid,cache_params{:});
[~,name,ext] = fileparts(img_url);
cc = [(img.width+1)/2 (img.height+1)/2];
dr = DR.get(img,cid_cache, ...
                {'type','all', ...
                 'reflection', false });
[x,Gsamp,Gapp] = group_desc(dr);    
[model_list,lo_res_list,stats_list] = ...
    rectify_planes(x,Gsamp,Gapp,solver,cc,varargin{:});
meas = struct('x',x,'Gsamp', Gsamp, 'Gapp', Gapp);