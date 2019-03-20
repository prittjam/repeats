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
cc = [(img.width)/2 (img.height)/2];
dr = DR.get(img,cid_cache, ...
                {'type','mser', 'reflection', false });
[x,G] = group_desc(dr);

G = filter_features(x,G,img);

[model_list,lo_res_list,stats_list] = ...
    rectify_planes(x,G,solver,cc,varargin{:});

meas = struct('x',x,'G',G);

function G = filter_features(x,G,img)
    areaT = 0.000035*img.area;
    G(find(abs(PT.calc_scale(x)) < areaT)) = nan;
    angles = LAF.calc_angle(x);
    G(find((angles < 1/10*pi) | (angles > 9/10*pi))) = nan;

    G = DR.rm_singletons(findgroups(G));