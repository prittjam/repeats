function varargout = render_rectification(u,u_corr,model,img,cc)
alignment = 'Similarity';

ind = find(~isnan(u_corr{:,'G_ij'}));
v = reshape(u(:,unique(u_corr{ind,'i'})),3,[]);

rtxn_idx = find(u_corr.MotionModel == 'HG.laf2xN_to_RtxN');
has_rotations = ~isempty(rtxn_idx);
has_reflections = ...
    numel(unique([model.Rt_i(4,:) ...
                  model.Rt_ij(4,:)]))==2;

if ~has_rotations && has_reflections
    alignment = 'Scale';
end
   
if model.q == 0
    assert(model.q == 0, 'Distortion coefficient is non-zero!');
    varargout{1} = IMG.rectify(img.data,model.Hinf, ...
                               'Align',alignment, ...
                               'good_points', v, ...
                               'Fill', [255 255 255]');
    if nargout == 2
        varargout{2} = img.data;
    end
else
    if nargin < 5
        cc = [img.width/2 img.height/2];
    end

    T0 = CAM.make_ru_div_tform(cc,model.q);
    varargout{1} = IMG.rectify(img.data,model.Hinf, ...
                               'ru_xform', T0, ...
                               'Align', alignment, ...
                               'good_points', v, ...
                               'Fill', [255 255 255]');
   
    if nargout == 2
        varargout{2} = IMG.ru_div(img.data,model.q, ...
                                  'Fill', [255 255 255]'); 
    end
end
