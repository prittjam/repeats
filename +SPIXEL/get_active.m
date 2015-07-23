function active = get_active(img,segments,active)
[A,B] = ismember(spixels,active_spixels);
active = A.*segments;