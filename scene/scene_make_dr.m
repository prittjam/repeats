function dr = scene_make_dr(detectors,dr)
global DESC DATA DR chains

if nargin < 2
    dr = struct;
end

detect(chains);
upgrade(chains);
describe(chains);

for i = 1:size(DATA.imgs)
    idx = 1;
    z = numel(dr{i});
    for j = 1:size(detectors,2)
        cfg = detectors{j};
        for k = cfg.subgenid
            if ~isempty(DESC.data{2,k,i})
                geom = ...
                    make_geom_array(DESC.data{2,k,i}.sift);
                sift = ...
                    make_sift_array(DESC.data{2,k,i}.sift);
                dr{i}(z) = scene_add_dr(cfg,geom,sift, ...
                                        cvdb_hash_img(scene_get_intensity_img(i)), ...
                                        k,idx);
                idx = dr{i}(z).id(end)+1;
                z = z+1;
            end
        end
    end
end

clear DESC DATA DR chains

function [dr,num_dr] = scene_add_dr(cfg,geom,sift,img_id,subgenid,idx)
[keys,subtypes,ids,subgenids] = cvdb_get_dr_keys(cfg);
dr = struct;

num_dr = size(geom,2);

dr.geom = geom;
dr.sifts = sift;
dr.id = [idx:idx+size(dr.geom,2)-1];
dr.s = true(ones(1,size(dr.geom,2)));
dr.num_dr = size(dr.geom,2);

dr.name = cfg.detector.name;

k = find(cfg.subgenid == subgenid)

dr.subgenid = subgenid;

if (numel(subtypes) > 0)
    dr.subtype.name = subtypes(k);
    dr.subtype.id = ids(k);
else
    dr.subtype.name = [];
    dr.subtype.id = [];
end

scene_put_dr(cfg,keys{k},img_id,dr);

function geom = make_geom_array(dr)
geom = [dr(:).a11; ...
        dr(:).a21; ...
        dr(:).a12; ...
        dr(:).a22; ...
        dr(:).x; ...
        dr(:).y];

function sifts = make_sift_array(dr)
sifts = reshape([dr(:).desc],128,[]);