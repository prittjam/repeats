function [dr,is_found,img_id] = scene_get_combined_dr(img_id,detectors,descriptor)
dr = scene_construct_dr();
is_found = logical(numel(detectors));

gid = 1;
for j = 1:numel(detectors)
    [d,is_found(j)] = scene_get_dr(img_id,detectors(j), ...
                                          descriptor,gid);
    if is_found(j)
        dr = cat(2,dr,d);
        gid = gid+num_dr;
    end
end