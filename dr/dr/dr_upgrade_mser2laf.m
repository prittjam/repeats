function res = dr_upgrade_mser2laf(dr_cfg,detector,res,img)
img = img.data;

if size(img,3)==1
  img=img(:,:,[1,1,1]);
end;

% get result and store it to appropriate field
%t = cputime;
[regs, affpts, cfg] = mexlafs(img, {res.rle} , 0, detector.upgrade_cfg);
%DR.data{imid, drid}.upgtime = cputime - t;

% output map of upgrades to dr
res.upg2dr  = [affpts.id];

% relabel upgraded regions
for i=1:numel(affpts)
   affpts(i).id=i;
end

res.affpt = affpts;
res.num_affpt = length(affpts);