%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function res = do_one_img(img_url,varargin)
repeats_init();
dbpath = fileparts(mfilename('fullpath'));
KeyValDb.getObj('dbfile', [dbpath '/features.db']); 
cfg = struct('solver', 'WRAP.laf222_to_ql');

[cfg,leftover] = cmp_argparse(cfg,varargin{:});
img = Img('url', img_url);  
cache_params = { 'read_cache', true, ...
                 'write_cache', true };
cid_cache = CidCache(img.cid,cache_params{:});
[~,name,ext] = fileparts(img_url);
cc = [(img.width+1)/2 (img.height+1)/2];
solver = feval(cfg.solver)
dr = DR.get(img,cid_cache, ...
                {'type','all', ...
                 'reflection', false });
[x,Gsamp,Gapp] = group_desc(dr);    
res = rectify_planes(x,Gsamp,Gapp,solver,cc,varargin{:});
rex.x = x;
res.Gsamp = Gsamp;
res.Gapp = Gapp;
