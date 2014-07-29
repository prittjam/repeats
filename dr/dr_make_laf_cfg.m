function upg_list = dr_make_laf_cfg(dr_defs,dr,varargin)
lafs_cfg = make_default_laf_cfg();
[lafs_cfg,leftover] = helpers.vl_argparse(lafs_cfg,varargin);
upgrade_hash = cfg2hash(lafs_cfg,1);

upg_list = struct;
for k = 1:numel(dr)
    upg_list(k).name = 'laf';
    upg_list(k).fqname = [dr(k).fqname ':' upg_list(k).name];
    upg_list(k).cfg = lafs_cfg;
    upg_list(k).key = cfg2hash(upg_list(k).cfg,true);

    upg_list(k).read_cache = 'On';
    upg_list(k).write_cache = 'On';

    [dr(k),leftover] = helpers.vl_argparse(dr(k),varargin{:});
end

upg_idx = dr_get_upgrade_ids(dr_defs,dr,upg_list);
if numel(upg_idx) ~= numel(dr)
    error;
end

function lafs_cfg = make_default_laf_cfg()
lafs_cfg = [];
% default = 0.5 delky hran rovnoramenneho trojuhelniku vepisovaneho do
% polygonu, uhel pak urcuje krivost
lafs_cfg.curvatureArcLength = 0.5;

% default = 1.0 vzdalenost (po hrani polygonu) pro non-maxima-suppression
% pri hledani maxim krivosti
lafs_cfg.curvatureNMSSpan = 1;

% default = true
lafs_cfg.doContourSmoothing = 1;
lafs_cfg.doRegressionPositioning = 0;
lafs_cfg.doInflectionPrecising = 0;
lafs_cfg.doLocalExtremaPrecising = 0;

% default = 0 - sigma derived from the size of the region by default,
% non-zero value fixed smoothing sigma
lafs_cfg.fixedContourSmoothingSigma = 0;

lafs_cfg.contourLinearApproximationDistanceThreshold = 0.033;

% default = true
lafs_cfg.ignoreQueryBlackPixels = 0;


lafs_cfg.lafExtremalCurvatureTreshold = 0.15; % cca 135
                                                            % stupnov

% default = 5, minimalni pocet pixelu v ramci, tj. determinant
% transformacni matice obrazek -> normalizovany ramec
lafs_cfg.lafMinimalFrameSize = 5;
lafs_cfg.lafTangentPointCurvatureTreshold = 0.1;
lafs_cfg.lafFarthestPointCurvatureTreshold = 0.15;
lafs_cfg.lafDoWeightRaster = 1;
lafs_cfg.lafRasterWeightsSigma = 2;
lafs_cfg.lafMaxNOfCurvatureExtremaPerDR = 5;
lafs_cfg.lafMinIntensityVariance = 10;
lafs_cfg.lafMinimalLinearSegmentLength = 2;


% LAF_CG_CURV_MIN      ///< 1: cov. matrix (CM) of DR + center of gravity (CoG) of DR + point of maximal concave curvature
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_CURV_MIN = 0;

% LAF_CG_CURV_MAX,     ///< 2: CM of DR + CoG of DR + point of maximal convex curvature
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_CURV_MAX = 1;

% LAF_2TP_CG,          ///< 3: 2 tangent points on a concavity + CoG of DR
lafs_cfg.lafConstructsToUse_LAF__LAF_2TP_CG = 0;

% LAF_2TP_CONT,        ///< 4: 2 tangent points on a concavity + point of DR contour most distant from the bitangent line
lafs_cfg.lafConstructsToUse_LAF__LAF_2TP_CONT = 0;

% LAF_2TP_CONC,        ///< 5: 2 tangent points on a concavity + point of the concavity most distant from the bitangent line
lafs_cfg.lafConstructsToUse_LAF__LAF_2TP_CONC = 1;

% LAF_2TP_CCG,         ///< 6: 2 tangent points on a concavity + CoG of the concavity
lafs_cfg.lafConstructsToUse_LAF__LAF_2TP_CCG = 0;

% LAF_CG_CCG,          ///< 7: CM of DR + CoG of DR + CoG of concavity
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_CCG = 0;

% LAF_CG_BT,           ///< 8: CM of DR + CoG of DR + bitangent direction
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_BT = 1;

% LAF_CCG_BT,          ///< 9: CM of concavity + CoG of concavity + bitangent direction
lafs_cfg.lafConstructsToUse_LAF__LAF_CCG_BT = 1;

% LAF_CG_GRAD,         ///< 10: CM of DR + CoG of DR + dominant gradient direction
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_GRAD = 0;

% LAF_JUNCTION,        ///< 11: junctions (not used with MSERs)
lafs_cfg.lafConstructsToUse_LAF__LAF_JUNCTION = 1;

% LAF_CG_VERTICAL,     ///< 12: CM of DR + CoG of DR + vertical direction
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_VERTICAL = 0;

% LAF_AFFINE_POINT_ORIENTATION, ///< 13: not used with MSERs
lafs_cfg.lafConstructsToUse_LAF__LAF_AFFINE_POINT_ORIENTATION = 1;

% LAF_LOWE_KEYPOINT,            ///< 14: not used with MSERs
lafs_cfg.lafConstructsToUse_LAF__LAF_LOWE_KEYPOINT = 0;

% LAF_CG_LINEAR_SEGMENT_DIR,    ///< 15: CM of DR + CoG of DR + direction of a linear segment of the DR boundary
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_LINEAR_SEGMENT_DIR = 0;

% LAF_CG_INFLECTION,   ///< 16: CM of DR + CoG of DR + inflection point of the contour
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_INFLECTION = 0;

% LAF_CG_HCG,          ///< 17: CM of DR + CoG of DR + CoG of a region hole
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_HCG = 0;

% LAF_HCG_CG,          ///< 18: CM of a region hole + CoG of of the hole + CoG of DR
lafs_cfg.lafConstructsToUse_LAF__LAF_HCG_CG = 0;

% LAF_CG_THIRD_MOMENT, ///< 19: CM of DR + CoG of DR + direction obtained from third moments
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_THIRD_MOMENT = 0;

% LAF_CG_DIST_MAX,     ///< 20: CM of DR + CoG of DR + point of maximal distance on normalised contour
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_DIST_MAX = 0;

% LAF_CG_DIST_MIN,     ///< 21: CM of DR + CoG of DR + point of minimal distance on normalised contour
lafs_cfg.lafConstructsToUse_LAF__LAF_CG_DIST_MIN = 0;
%lafs_cfg.forestFname = [evalin('base = 'start_path') '/desc/lafs/decisionForest'])

% lafdetector
lafs_cfg.minMargin = 1;
lafs_cfg.minSize = 30;
lafs_cfg.maxPercent = .1;
lafs_cfg.stability = 8;
lafs_cfg.minOverlap = .25;
lafs_cfg.minLevelOverlap = .15;
lafs_cfg.suppressOverlap = .3;

%      GLOBAL_CONSISTENCY_NONE = 0, ///< 0: No TC pruning

%      GLOBAL_CONSISTENCY_TUYTELAARS, ///< 1: method by Tinne Tuytelaars,
%      it never worked

%      GLOBAL_CONSISTENCY_MULTIPLE_PLANES, ///< 2: a TC is kept if at least
%      parameters.matchingNConsistent other TCs have similar transformation

%      GLOBAL_CONSISTENCY_BEST_PLANE, ///< 3: only a maximal subset of TCs
%      that have similar transformation is kept.
lafs_cfg.matchingGlobalConsistencyType = 'GLOBAL_CONSISTENCY_MULTIPLE_PLANES';

%      MATCHING_STRATEGY_ALL_NEAR, ///< 1: TC: query frame <-> all DB
%      frames that are closer the the query one than
%      parameters.matchingMaximalInterestingDistance

%      MATCHING_STRATEGY_NEAREST, ///< 2: TC: query frame <-> closest of DB
%      frames, if closer than parameters.matchingMaximalInterestingDistance

%      MATCHING_STRATEGY_BIDIRECTIONAL_NEAREST, ///< 3: TC: query frame <->
%      closest of DB frames together with DB frame <-> closest query frame

%      MATCHING_STRATEGY_MUTUALLY_NEAREST, ///< 4: TC: query frame <->
%      closest of DB frames if simultaneously DB frame <-> closest query
%      frame

%      MATCHING_STRATEGY_N_NEAREST, ///< 5: TC: query frame <-> up to
%      parameters.matchingNNearest closest DB frames
lafs_cfg.matchingStrategy = 'MATCHING_STRATEGY_MUTUALLY_NEAREST';

% pro kazdy DBF ramec pocet blizkych ramcu  ze sceny do pairedIndices
lafs_cfg.matchingNNearest = 2;

% pocet konzistentnich pri overovani globalni konzistence
lafs_cfg.matchingNConsistent = 4;

% true ma-li byt pouzita normalizovana korelace
lafs_cfg.matchingNormalizedCorrelation = 1;

% transformace jednotlivych bar. kanalu: y = a(x + b)
lafs_cfg.matchingAllowedIntensityScale = 4; % = 1.5, pomer prumernych intensit v jednotlivych kanalech ~ a
lafs_cfg.matchingAllowedIntensityOffset = 999; % = 50, rozdil prumernych intensit v jednotlivych kanalech ~ b
lafs_cfg.matchingAllowedChromaticityChange = 0.1; % = 0.1, maximalni vzd. prumerne barvy na chromaticke rovine

% default = 0.5 0..1
lafs_cfg.matchingMaximalInterestingDistance = 0.2;

% unused 
lafs_cfg.matchingMaximalDiscriminantDifference = 999.5;

% default = 4*4,     ! druha mocnina ! maximalni povolena hodnota determinantu transformacni matice model -> obraz
lafs_cfg.matchingMaximalModelToImageScale = 16;

% default = 0.25*0.25, ! druha mocnina ! minimalni povolena hodnota determinantu transformacni matice model -> obraz
lafs_cfg.matchingMinimalModelToImageScale = 0.0625;

% defalt = 3 maximalni povoleny pomer vl. cisel transformacni matice model -> obraz
lafs_cfg.matchingMaximalAnisotropicScale = 4;

% default = M_PI/18  povoleny uhel projekce svisle osy
lafs_cfg.matchingMaximalHorizontalDeviation = 6.28319;

% 0..1, 1 pro vsechny nejblizsi matche
lafs_cfg.matchingMaximalFirstAndSecondDistanceRatio = 0.99;

% dirty hack, leaving only one corespondence per each DR pair
lafs_cfg.matchingOneCorrespondencePerDR = 0;
lafs_cfg.verbose = 0;

% we don't want to accidentally get different settings when in directory with lafs.cfg
lafs_cfg.ignoreLafsCfg = 1;
lafs_cfg.skipRasterisationAndDescription = 1;
lafs_cfg.outputFormat = 1;