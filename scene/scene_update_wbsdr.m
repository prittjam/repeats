function [] = scene_update_wbsdr(subgenid,upgrade)
global DR

DR.current      = unique(cat(2,subgenid,DR.current));
[~,ia]          = intersect(DR.current,subgenid);
DR.upgrades(ia) = upgrade;