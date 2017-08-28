function [timg,T,A] = render_rectification(u,model,img,cc)
alignment = 'Similarity';

ind = find(~isnan(model.u_corr{:,'G_ij'}));
v = reshape(u(:,unique(model.u_corr{ind,'i'})),3,[]);

rtxn_idx = find(model.u_corr.MotionModel == 'Rt');
has_rotations = ~isempty(rtxn_idx);
has_reflections = ...
    numel(unique([model.Rt_i(4,:) ...
                  model.Rt_ij(4,:)]))==2;

if ~has_rotations && has_reflections
    alignment = 'Scale';
end
   
if model.q == 0
    T0 = [];
else
    T0 = CAM.make_ru_div_tform(cc,model.q);
end
    
[timg,T,A] = IMG.rectify(img, model.Hinf, ...
                         'ru_xform', T0, ...
                         'Align', alignment, ...
                         'good_points', v, ...
                         'Fill', [255 255 255]');
