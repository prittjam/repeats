function img = scene_find_img_by_name(img_set,name)
for img = img_set
    [~,name2,ext] = fileparts(img.url);
    is_found = strcmp(name,[name2 ext]);
    if is_found 
        return;
    end
end

img = [];