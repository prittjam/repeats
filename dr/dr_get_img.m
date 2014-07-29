function [dtct,upg] = dr_get_img(dr_defs,dtct_cfg_list,upg_cfg_list,img,img_cache)
dtct = cell(1,numel(dtct_cfg_list));
is_found = false(1,numel(dtct_cfg_list));

%for k = 1:numel(dtct_cfg_list)
%    if strcmp(dtct_cfg_list(k).read_cache,'On')
%        dtct{k} = img_cache.get('dr',dtct_cfg_list(k).name,dtct_cfg_list(k).key);
%    end
%end
%
not_found = cellfun(@isempty,dtct);
if any(not_found)
    dtct(not_found) = dr_detect(dr_defs, ...
                                dtct_cfg_list(not_found),img);
end

for k = find(not_found)
    img_cache.put('dr',dtct{k}.uname,dtct_cfg_list(k).key,dtct{k});
end

upg = cell(1,numel(upg_cfg_list));
for k = 1:numel(upg_cfg_list)
    if strcmp(upg_cfg_list(k).read_cache,'On')
        upg{k} = img_cache.get('dr', ...
                               [dtct_cfg_list(k).name ':' upg_cfg_list(k).name], ...
                               upg_cfg_list(k).key,dtct_cfg_list(k).name);
    end
end

not_found = cellfun(@isempty,upg);
if any(not_found)
    upg(not_found) = dr_upgrade(dr_defs, ...
                                dtct_cfg_list(not_found), ...
                                upg_cfg_list(not_found), ...
                                dtct(not_found),img);
end
    
for k = find(not_found)
    img_cache.put('dr',upg{k}.uname, ...
                  upg_cfg_list(k).key,upg{k}, ...
                  'overwrite',false,'parents',{dtct{k}.uname});
end