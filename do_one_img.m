%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [model_list,lo_res_list,stats_list,meas,img] = ...
        do_one_img(img_url,solver,varargin)
    repeats_init();
    warning('off', 'MATLAB:nearlySingularMatrix');
    rng('shuffle')
    dbpath = fileparts(mfilename('fullpath'));
    KeyValDb.getObj('dbfile', [dbpath '/features.db']); 
    img = Img('url', img_url);  
    cache_params = { 'read_cache', true, ...
                     'write_cache', true };
    cid_cache = CidCache(img.cid,cache_params{:});
    cc = [(img.width)/2 (img.height)/2];
    dr = DR.get(img,cid_cache, ...
                    {'type','mser', 'reflection', true});
    x = [dr(:).u];
    G = DR.group_desc(dr);
    clear dr;
    G = filter_features(x,G,img);
    G = limit_group_size(x,G,50);
    [x,G] = limit_drs(x,G,1000);
    
    x = x(:,~isnan(G));
    G = G(~isnan(G));
    
    [model_list,lo_res_list,stats_list] = ...
        rectify_planes(x,G,solver,cc,varargin{:});
    
    meas = struct('x',x,'G',G);

function G = filter_features(x,G,img)
    areaT = 0.000035*img.area;
    G(find(abs(PT.calc_scale(x)) < areaT)) = nan;
    angles = LAF.calc_angle(x);
    G(find((angles < 1/10*pi) | (angles > 9/10*pi))) = nan;
    G = DR.rm_singletons(findgroups(G));
    
function G = limit_group_size(x,G,T)
    freq = hist(G,1:max(G));
    breakit = find(freq > T);
    for k = breakit
        ind = find(G == k);
        m = ceil(freq(k)/T);
        Gp = repmat([1:m],T,1)+max(G);
        Gp = Gp(1:end-(numel(Gp)-numel(ind)));
        G(ind) = Gp;
    end
    G = DR.rm_singletons(findgroups(G));
    
function [x,G] = limit_drs(x,G,T)
    freq = hist(G,1:max(G));
    [sfreq,ind0] = sort(freq,'descend');
    csum = cumsum(sfreq);
    ind1 = find(csum > T);
    rmind = ind0(ind1);
    [Lia,Lib] = ismember(G',rmind' ,'rows');
    G(Lia) = nan;
    G = findgroups(G);