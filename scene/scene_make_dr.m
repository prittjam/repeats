function dr = scene_make_dr(img,cfg)
dr = [];

switch cfg.detector.name
  case {'haff3_na', 'haff3', 'hess3_na', 'hess3', 'haff3_na_stbl', 'haff2_na', 'haff2', 'hess2_na', 'hess2', 'haff_na', 'haff'}
    pts = kmpts2(img,cfg.detector);
    if( ~isempty( pts ) && isfield(pts,'affpt'))
        dr.geom = make_geom_array(pts.affpt);
        dr.sifts = make_sift_array(pts.affpt);
    else
        dr = [];
    end

  case {'mser'}
    % msers + DL rotation
    msers = extrema(img,cfg.detector);
    dr = struct;
    for j = 1:numel(cfg.detector.subtype.tbl)
        pts = affpatch(img,[msers{j}{2,:}],wbs_default_cfg());
        dr.(cfg.detector.subtype.tbl{j}).geom = make_geom_array(pts.affpt); 
        dr.(cfg.detector.subtype.tbl{j}).sifts = ...
            make_sift_array(pts.affpt);
    end
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