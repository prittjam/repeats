function [timg,T,A] = render_rectification(x,model,img,varargin)
ind = find(~isnan(model.Gs));
v = reshape(x(:,ind),3,[]);

if model.q == 0
    T0 = [];
else
    T0 = CAM.make_ru_div_tform(model.cc,model.q);
end

[timg,T,A] = IMG.rectify(img, model.Hinf, ...
                         'ru_xform', T0, ...
                         'good_points', v, ...
                         'Fill', [255 255 255]', ...
                         varargin{:});
