function res = extract(cfg_chains,img,res)
if (nargin < 3) || isempty(res)
    res = cellfun(@(x) cell(size(x)),cfg_chains,'UniformOutput',false);
end

doit = cellfun(@(x) cellfun(@(y) isempty(y),x), ...
               res,'UniformOutput',false);

syscfg = SysCfg();
gens = syscfg.cfgs_to_gens(cfg_chains);
names = cellfun(@(x) cellfun(@(y) class(y),x,'UniformOutput',false), ...
                gens,'UniformOutput',false);

while any([doit{:}])
    cfgs = cellfun(@(x) min(find(x)),doit,'UniformOutput',false);
    active_chains = find(cellfun(@(x) ~isempty(x),cfgs));
    active_cfgs = [cfgs{active_chains}];
    cur_gens = cellfun(@(x,y) x{y}, gens(active_chains), num2cell(active_cfgs), ...
                       'UniformOutput',false);
    cur_names = cellfun(@(x) class(x), cur_gens, ...
                        'UniformOutput',false);
    [unames,ia,ic] = unique(cur_names,'stable');
    ugens = cur_gens(ia);
    for k = 1:numel(ia)
        same_cfg = active_cfgs(find(ic == k)');
        same_chains = active_chains(find(ic == k)');
        same_cfgs = cellfun(@(x,y) x(y), cfg_chains(same_chains)', ...
                            num2cell(same_cfg));
        prev_res = cellfun(@make_prev_res, res(same_chains)', ...
                           num2cell(same_cfg), 'UniformOutput', false);
        tmp_res = ugens{k}.make(img,same_cfgs,prev_res);
        for k2 = 1:numel(tmp_res)
            res{same_chains(k2)}(same_cfg(k2)) = tmp_res(k2);
        end
    end
    doit = cellfun(@(x) cellfun(@(y) isempty(y),x), ...
                   res,'UniformOutput',false);
end

function prev_res = make_prev_res(x,y)
    if y == 1
        prev_res = [];
    else
        prev_res = x{y-1};
    end


%cur_cfg_chain = cellfun(@(x,y) x{y},cfg_chain,num2cell(curi), ...
%                            'UniformOutput',false);    
%end
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