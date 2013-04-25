function [pair,ind] = scene_find_stereo_pair_by_name(stereo_set,name)
ind = 0;

for pair = stereo_set
    ind = ind+1;
    [~,name2,ext] = fileparts(pair.img1.url);
    [~,name3,ext] = fileparts(pair.img2.url);
    ind2 = strfind([name2 ext ' ' name3 ext],name);
    
    if ~isempty(ind2)
        return;
    end
end

ind = -1;
img = [];