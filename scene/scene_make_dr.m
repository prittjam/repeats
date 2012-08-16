function dr_set = scene_make_dr(detectors,dr_set)
global DESC DATA DR chains

if nargin < 2
    dr_set = {};
end

detect(chains);
upgrade(chains);
describe(chains);

for i = 1:size(DATA.imgs,2)
    gid = 1;
    dr = scene_construct_dr();
    for j = 1:size(detectors,2)
        cfg = detectors{j};
        for k = cfg.subgenid
            if (DR.valid(i,k))
                if (DR.data{i,k}.num_dr > 0)
                    geom = ...
                        make_geom_array(DESC.data{2,k,i}.sift);
                    sift = ...
                        cfg.sift.normalize(double(make_sift_array(DESC.data{2,k,i}.sift)));
                    dr = cat(2,dr,scene_add_dr(cfg,geom,sift, ...
                                               cvdb_hash_img(scene_get_intensity_img(i)), ...
                                               k,gid));
                    gid = dr(end).id(end)+1;
                else
                    geom = [];
                    sift = [];
                    dr = cat(2,dr,scene_add_dr(cfg,geom,sift, ...
                                               cvdb_hash_img(scene_get_intensity_img(i)), ...
                                               k,gid));
                end
            end
        end
    end
    dr_set = cat(2,dr_set,dr);
end

clear DESC DATA DR chains

function [dr,num_dr] = scene_add_dr(cfg,geom,sift,img_id,subgenid,gid)
[keys,subtypes,ids,subgenids] = cvdb_get_dr_keys(cfg);
dr = struct;

num_dr = size(geom,2);

dr.geom = geom;
dr.u = laf_get_3p_from_A(laf_unwrap_A(geom));
dr.sifts = sift;
dr.id = [1:size(dr.geom,2)];
dr.gid = [gid:gid+size(dr.geom,2)-1];
dr.s = true(ones(1,size(dr.geom,2)));
dr.num_dr = size(dr.geom,2);

dr.name = cfg.detector.name;

k = find(cfg.subgenid == subgenid);

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