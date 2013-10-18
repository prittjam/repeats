function res = desc_aff2sift(desc_defs,descriptor,img,dr)
for k = 1:numel(dr)
    pts = dr.affpt;
    res = affpatch(img.intensity, pts, descriptor.sift_cfg);
    if isfield(res,'affpt')
        affpt = res.affpt;
    else
        % GV points are output as ellpt 
        affpt = res.ellpt;
    end;
    
    res.sift    = affpt;
    res.desc2dr = [affpt.id];
    res.num_desc = length(affpt);
end
