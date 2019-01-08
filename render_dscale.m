%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function sc_img = ...
    render_dscale(dims,H,cc,q,v)
l = H(3,:)';
x =  PT.renormI(H*CAM.ru_div(v,cc,q));
idx = convhull(x(1,:),x(2,:));
mux = mean(x(:,idx),2); 
pt = CAM.rd_div(PT.renormI(inv(H)*mux),cc,q);

[rect_rd_div_dscale_img,si_fn] = IMG.calc_dscale(dims,l,cc,q);
ref_sc = si_fn(1,l(1),l(2),q,1,pt(1),pt(2));
sc_img = rect_rd_div_dscale_img/ref_sc;

ru_xform = CAM.make_ru_div_tform(cc,q);
[rect_dscale_img,si_fn,rect] = IMG.calc_dscale(dims,l,'RuXform',ru_xform);
pt = PT.renormI(inv(H)*mux);
ref_sc = si_fn(l(1),l(2),1,pt(1),pt(2));
rect_dscale_img = rect_dscale_img/ref_sc;