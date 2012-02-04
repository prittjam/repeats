function dr = scene_make_dr(detectors,dr)
global DESC DATA DR chains

if nargin < 2
    dr = {};
end

detect(chains);
upgrade(chains);
describe(chains);

for i = 1:size(DESC.data,3)
    for j = 1:size(detectors,2)
        cfg = detectors{j};
        is_new_dr = false;
        for k = 1:numel(cfg.subgenid)
            if ~isempty(DESC.data{2,k,i})
                geom = ...
                    make_geom_array(DESC.data{2,cfg.subgenid(k),i}.sift);
                sift = ...
                    make_sift_array(DESC.data{2,cfg.subgenid(k),i}.sift);
                dr{i} = scene_add_dr(dr{i},cfg,geom,sift,k);
            end
        end
        if is_new_dr
            scene_put_dr(detectors{j}, ...
                         cvdb_hash_img(scene_get_intensity_img(i)), ...
                         dr{i});
        end
    end
end

function dr = scene_add_dr(dr,cfg,geom,sift,subgenid)
if nargin < 5
    subtype = [];
end

if isfield(cfg, 'subtype')
    subtype = cfg.subtype;
    dr.(cfg.detector.name).(subtype.tbl{subgenid}).geom = geom;
    dr.(cfg.detector.name).(subtype.tbl{subgenid}).sifts = sift;
else
    dr.(cfg.detector.name).geom = geom;
    dr.(cfg.detector.name).sifts = sift; 
end

function geom = make_geom_array(dr)
geom = [dr(:).x; ...
        dr(:).y; ...
        dr(:).a11; ...
        dr(:).a12; ...
        dr(:).a21; ...
        dr(:).a22];

function sifts = make_sift_array(dr)
sifts = reshape([dr(:).desc],128,[]);