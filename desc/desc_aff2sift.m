function res = desc_aff2sift(desc_defs,descriptor,img,dr)
for k = 1:numel(dr)
    res = affpatch(img.intensity, dr.affpt, descriptor.sift_cfg);
    res.desc2dr = [res.affpt(:).id];
    res.num_desc = length(res.affpt);

    % WBS convention
%    if isfield(res,'affpt')
%        affpt = res.affpt;
%    else
%        % GV points are output as ellpt 
%        affpt = res.ellpt;
%    end;
%    res.sift = affpt;
end