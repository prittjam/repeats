function warp_err = verify_reflections()
[x,G,cspond,cc,P,q_gt,X] = PLANE.make_reflected_scene();
varargin = { 'motion_model', 't' };

l_gt = P' \ [0 0 1]';

eval = RepeatEval(cspond);

gtM = struct('H', inv(P),  ...
             'q', q_gt, ...
             'cc', cc, ...
             'l', l_gt);
eval.calc_loss(x,gtM);

solver = WRAP.lafmn_to_qAl(WRAP.laf2_to_ql, ...
                           'upgrade_fn',@laf2_to_Amur);
[model_list,lo_res_list,stats_list] = ...
    rectify_planes(x,G,solver,cc,varargin{:});
warp_err = TEST.calc_warp_err(reshape(x,3,[]),l_gt,q_gt, ...
                              model_list.l,model_list.q,cc);
display(['Affine warp error is: ' num2str(warp_err)]);

keyboard;