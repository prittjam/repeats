function res = dr_detect_msers(dr_defs,dr,img)
% create subdetector id list
subids = dr_get_subids(dr_defs,dr);
msg(1,'MSER detection (%s):\n', img.url);

%a = enhance_image(DATA.imgs(img_id).data);
a = img.data;

if (check_flag('CFG.extrema.presmooth')>0)
   sigma = CFG.extrema.presmooth;
   g = fspecial('gaussian', 6*sigma, sigma);
   a(:,:,1) = conv2(a(:,:,1), g,'same');
   a(:,:,2) = conv2(a(:,:,2), g,'same');
   a(:,:,3) = conv2(a(:,:,3), g,'same');
end;

if (numel(unique({dr(:).key})) == 1)
    [mser img det_time] = extrema(a, dr(1).cfg, subids);
else
    error('Configuration is different for subtypes');
end

res = {};
% store msers and images in apropriate cells
for k = 1:numel(subids)
    ind = 1:numel(mser{k});
    %    res{k}.rle = dr_rm_overlapping_msers(dr(k),mser{k});   
    res{k}.rle = mser{:,k};
    res{k}.num_dr = size(res{k}.rle,2);
    res{k}.time = det_time(k);
end

