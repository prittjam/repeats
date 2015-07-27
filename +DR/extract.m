function res2 = extract(cfg_chain,img,res)
if (nargin < 3) || isempty(res)
    res = cellfun(@(x) cell(size(x)),cfg_chain,'UniformOutput',false);
end

doit = cellfun(@(x) cellfun(@(y) isempty(y),x), ...
               res,'UniformOutput',false);

syscfg = DR.Syscfg();
gens = syscfg.cfgs_to_gens(cfg_chain);
names = cellfun(@(x) cellfun(@(y) class(y),x,'UniformOutput',false), ...
                gens,'UniformOutput',false);

while any([doit{:}])
    inds = cellfun(@(x) min(find(x)),doit, ...
                   'UniformOutput',false);
    active_chains = find(cellfun(@(x) ~isempty(x),inds));
    active_inds = inds{active_chains};
    cur_gens = cellfun(@(x,y) x{y}, gens(active_chains), inds', ...
                       'UniformOutput',false);
    cur_names = cellfun(@(x) class(x), cur_gens, ...
                        'UniformOutput',false);
    [unames,ia,ic] = unique(cur_names,'stable');
    ugens = cur_gens(ia);
    for k = 1:numel(ia)
        same_ind = find(ic == ia(k));
        same_chains = active_chains(same_ind);

        same_cfgs = same_ind
        ugens{ia}.make(img,cfg_chain{same}{inds{same}});
    end
end
kkk = 3;
%    cur_cfg_chain = cellfun(@(x,y) x{y},cfg_chain,num2cell(curi), ...
%                            'UniformOutput',false);    
%end
%        
%    
%
%
%
%
%while( ~all(cellfun(@(x) isempty(x),curgen)) )
%
%
%    ugens = curgen(ia);
%
%    notempty = find(~cellfun(@(x) strcmp(x,'double'),curname));
%    i = find(notempty(1) == ia);
%    prevres(same) = ugens{i}.make(img,cfgs(same),prevres(same));
%    same = ic == i;
%
%    fsame = find(same);
%    for k = 1:numel(fsame)
%        res{fsame(k)}{curi(fsame(k))} = prevres{fsame(k)};
%    end
%    last = arrayfun(@(x,y) x==y,curi,sizes);
%    curi(same & ~last) = curi(same & ~last) + 1;
%    curgen = cellfun(@(x,y) x{y}, gens,num2cell(curi'),'UniformOutput',false);
%    curgen(last) = {[]};
%end
%end