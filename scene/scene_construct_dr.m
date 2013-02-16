function dr = scene_construct_dr(geom,sift,cls,gid,subgenid,cfg,img_id)
num_dr = 0;
if nargin < 1
    dr = struct('geom',{}, ...
                'u',{}, ...
                'sifts',{}, ...
                'xsifts',{}, ...
                'id',{}, ...
                'gid',{}, ...
                's',{}, ...
                'num_dr',{}, ...
                'name',{}, ... 
                'subgenid',{}, ...
                'img_id',{}, ...
                'key',{}, ...
                'subtype',{}, ...
                'class',{});
else
    dr = struct;

    [keys,subtypes,ids,subgenids] = cvdb_get_dr_keys(cfg);

    [scls,ind] = sort(reshape(cls,1,[]),'ascend');
    dr.geom = geom(:,ind);
    dr.u = laf_get_3p_from_A(laf_unwrap_A(dr.geom));
    dr.sifts = sift(:,ind);
    dr.xsifts = cfg.sift.normalize(dr.sifts);
    dr.id = [1:size(dr.geom,2)];
    dr.gid = [gid:gid+size(dr.geom,2)-1];
    dr.s = true(1,size(dr.geom,2));
    dr.num_dr = size(dr.geom,2);
    dr.name = cfg.detector.name;
    dr.subgenid = subgenid;
    dr.img_id = img_id;
    k = find(cfg.subgenid == subgenid);
    dr.key = keys{k};
    if (numel(subtypes) > 0)
        dr.subtype.name = subtypes(k);
        dr.subtype.id = ids(k);
    else
        dr.subtype.name = [];
        dr.subtype.id = [];
    end
    dr.class = scls;
end