function res = dr_upgrade(dr_defs,detectors,res,img)
% UPGRADE upgrades detected regions according to chain rules provided
%   Assumes, that images with IMG_IDS have been loaded using LOAD_IMG.   
   
% do whole upgrade phase
msg(1,'\n');

% any upgrades requested?
% there is something to upgrade

msg(1, 'Upgrading regions (%s):\n', img.url);
% get generators requested on this image

% for each detector/upgrade combination (generator)
for k = 1:numel(detectors)
    drid = dr_get_drids(dr_defs,detectors(k));
    upgrade = dr_get_upgrades(dr_defs,detectors(k));
    upg_ids = dr_get_upgrade_ids(dr_defs,detectors(k));
    if ~isempty(upg_ids)
        active_upg = upgrade{1}{upg_ids};
        % perform upgrade
        try 
            res{k} = active_upg{2}(dr_defs,detectors(k),res{k}, ...
                                   img);
            res{k}.upgrade = detectors(k).upgrade;
        catch
            err = lasterror;
            dump_stack(sprintf('Upgrade of region %d failed:', drid), err);
        end
    end
end