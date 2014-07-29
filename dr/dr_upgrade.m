function upg = dr_upgrade(dr_defs,dtct_cfg_list,upg_cfg_list,dtct,img)
% UPGRADE upg_cfg_list detected regions according to chain rules provided
%   Assumes, that images with IMG_IDS have been loaded using LOAD_IMG.   
   
% do whole upgrade phase
msg(1,'\n');

% any upgrades requested?
% there is something to upgrade

msg(1, 'Upgrading regions (%s):\n', img.url);
% get generators requested on this image

% for each detector/upgrade combination (generator)
upg = cell(1,numel(dtct_cfg_list));
for k = 1:numel(dtct_cfg_list)
    drid = dr_get_drids(dr_defs,dtct_cfg_list(k));
    upgrade = dr_get_upgrades(dr_defs,dtct_cfg_list(k));
    upg_ids = dr_get_upgrade_ids(dr_defs,dtct_cfg_list(k),upg_cfg_list(k));
    if ~isempty(upg_ids)
        active_upg = upgrade{1}{upg_ids};
        % perform upgrade
        try 
            upg{k} = active_upg{2}(dr_defs,upg_cfg_list(k), ...
                                   dtct{k},img);
            upg{k}.name = upg_cfg_list(k).name; 
            upg{k}.uname = [dtct{k}.name ':' upg{k}.name];
        catch
            err = lasterror;
            dump_stack(sprintf('Upgrade of region %d failed:', drid), err);
        end
    end
end