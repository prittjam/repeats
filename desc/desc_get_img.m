function res = desc_get_img(desc_defs,desc_cfg_list,dr,img,img_cache)
desc = cell(1,numel(desc_cfg_list));
is_found = false(1,numel(desc_cfg_list));

for k = 1:numel(desc_cfg_list)
    if strcmp(desc_cfg_list(k).read_cache,'On')
        desc{k} = img_cache.get('dr',desc_cfg_list(k).name,desc_cfg_list(k).key);
    end
end

not_found = cellfun(@isempty,desc);
if any(not_found)
    desc(not_found) = desc_describe(desc_defs, ...
                                    desc_cfg_list(not_found),dr,img);
end

for k = find(not_found)
    img_cache.put('descriptors', ...
                  upg_cfg_list(k).key,upg{k}, ...
                  'overwrite',false,'parents',{(k).name});
end