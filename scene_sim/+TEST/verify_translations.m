function [] = verify_translations
%solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);
solver = WRAP.lafmn_to_qAl(WRAP.laf2_to_ql());
[x,G,cc,P,q_gt,X] = PLANE.make_translated_scene();
varargin = {};
[model_list,lo_res_list,stats_list] = ...
    rectify_planes(x,G,solver,cc,varargin{:});