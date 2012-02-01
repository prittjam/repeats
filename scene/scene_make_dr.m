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
    msers = extrema(img,cfg.detector,cfg.detector.subtype.id);
    dr = struct;
    for j = 1:numel(cfg.detector.subtype.tbl)
        if isfield(cfg.detector,'laf')
            [~, lafs] = mexlafs(img,msers{j},0,cfg.detector.laf);
        end
        %    lafs = lafs';
        pts = affpatch(img,[msers{j}{2,:}],wbs_default_cfg());
        [lafs_desc patches] = affpatch(img, lafs, p);
        dr.(cfg.detector.subtype.tbl{j}).geom = make_geom_array(pts.affpt); 
        dr.(cfg.detector.subtype.tbl{j}).sifts = ...
            make_sift_array(pts.affpt);
    end

end

function lafs = make_laf_struct(dr)
lafs = struct('x',dr(:).transformation(1,3),...
              'y',dr(:).transformation(2,3),...
              'a11',dr(:).transformation(1,1),...
              'a12',dr(:).transformation(1,2),...
              'a21',dr(:).transformation(2,1),...
              'a22',dr(:).transformation(2,2));

function geom = make_geom_array(dr)
geom = [dr(:).x; ...
        dr(:).y; ...
        dr(:).a11; ...
        dr(:).a12; ...
        dr(:).a21; ...
        dr(:).a22];

function sifts = make_sift_array(dr)
sifts = reshape([dr(:).desc],128,[]);