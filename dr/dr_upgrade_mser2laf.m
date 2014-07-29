function upg = dr_upgrade_mser2laf(dr_cfg,upg_cfg,res,img)
img = img.data;

if size(img,3)==1
  img=img(:,:,[1,1,1]);
end;

% get result and store it to appropriate field
%t = cputime;
[regs, affpts, cfg] = mexlafs(img, {res.rle}, 0, upg_cfg.cfg);
%DR.data{imid, drid}.upgtime = cputime - t;

upg = struct;
% output map of upgrades to dr
upg.upg2dr  = [affpts.id];

% relabel upgraded regions
for i=1:numel(affpts)
   affpts(i).id=i;
end

upg.affpt = affpts;
upg.num_upg = length(affpts);