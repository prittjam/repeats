function [uimg,rimg,sc_img] = render_images(img,meas,model,res)
[ny,nx,~] = size(img);
ind = find(~isnan(model.Gm));
x = reshape(meas.x(:,unique(res.info.cspond(:,res.cs))),3,[]);
l = PT.renormI(transpose(model.H(3,:)));   

uimg = IMG.ru_div(img,model.cc,model.q);
[border,sc_img] = IMG.calc_rectification_border(size(img),l,model.cc,model.q,0.1,10,x);
[rimg,trect,tform] = IMG.ru_div_rectify(img,model.H,model.cc,model.q, ...
                                        'cspond', x, 'border', border, ...
                                        'Registration','Similarity');