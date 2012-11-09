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
                        make_sift_array(DESC.data{2,k,i}.sift);
                    cls = ...
                        make_laf_class_array(DESC.data{2,k,i}.sift);
                    dr = cat(2,dr,scene_add_dr(cfg,geom,sift,cls, ...
                                               cvdb_hash_img(scene_get_intensity_img(i)), ...
                                               k,gid));
                    gid = dr(end).id(end)+1;
                else
                    geom = [];
                    sift = [];
                    dr = cat(2,dr,scene_add_dr(cfg,geom,sift,cls, ...
                                               cvdb_hash_img(scene_get_intensity_img(i)), ...
                                               k,gid));
                end
            end
        end
    end
    dr_set = cat(2,dr_set,dr);
end

clear DESC DATA DR chains

function [dr,num_dr] = scene_add_dr(cfg,geom,sift,cls,img_id,subgenid,gid)
num_dr = size(geom,2);
dr = scene_construct_dr(geom,sift,cls,gid,subgenid,cfg,img_id);
scene_put_dr(img_id,dr);

function geom = make_geom_array(dr)
geom = [dr(:).a11; ...
        dr(:).a21; ...
        dr(:).a12; ...
        dr(:).a22; ...
        dr(:).x; ...
        dr(:).y];

function sifts = make_sift_array(dr)
sifts = reshape([dr(:).desc],128,[]);

function cls = make_laf_class_array(dr)
cls = reshape([dr(:).class],1,[]);