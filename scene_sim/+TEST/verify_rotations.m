function [] = verify
solver = WRAP.lafmn_to_qAl(WRAP.laf222_to_ql);
%solver = WRAP.lafmn_to_qAl(WRAP.laf22_to_l());
[x,G,cc] = TEST.make_scene();
varargin = {};
[model_list,lo_res_list,stats_list] = ...
    rectify_planes(x,G,solver,cc,varargin{:});