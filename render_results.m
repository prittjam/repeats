function varargout = render_results(u,u_corr,model,img,cc)
ind = find(~isnan(u_corr{:,'G_ij'}));
v = reshape(u(:,unique(u_corr{ind,'i'})),3,[]);

if model.q == 0
    assert(model.q == 0, 'Distortion coefficient is non-zero!');
    varargout{1} = IMG.rectify(img.data,model.Hinf, ...
                               'Align','Yes', ...
                               'good_points', v, ...
                               'Fill', [255 255 255]');
else
    if nargin < 5
        cc = [img.width/2 img.height/2];
    end

    T0 = CAM.make_rd_div_tform(cc,model.q);
    varargout{1} = IMG.rectify(img.data,model.Hinf, ...
                               'Transforms', { T0 }, ...
                               'Align', 'Yes', ...
                               'good_points', v, ...
                               'Fill', [255 255 255]');
   
    if nargout == 2
        varargout{2} = IMG.ru_div(img.data,cc,model.q, ...
                                  'Fill', [255 255 255]'); 
    end
end
