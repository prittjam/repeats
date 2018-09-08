%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw_reconstruction(ax,Rti,Gs,X,H)
vertex_data = ...
    composite_xforms(Tlist,Gm,inverted,...
                     Rtij,X,num_vertices)

[Xp,inl] = sfm(X,vertex_data)
inl = find(~isnan(vertex_data.Gs));
inlGs = reshape(vertex_data.Gs(inl),1,[]);
Y = X(:,inlGs);
Rti = [vertex_data.Rti(inl,:)]';
Xp = LAF.apply_rigid_xforms(Y,Rti);


inl = find(~isnan(Gs));
inlGs = reshape(Gs(inl),1,[]);
Y = X(:,inlGs);
Rti = [Rti(inl,:)]';
Yii = LAF.apply_rigid_xforms(Y,Rti);
invH = inv(H);
x = LAF.renormI(blkdiag(invH,invH,invH)*[X Yii]);
LAF.draw_groups(gca,x,[1:size(X,2) inlGs],'LineWidth',3);
