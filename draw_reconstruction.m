function [] = draw_reconstruction(ax,rtree,X)
inl = find(~isnan(rtree.Nodes.Gs));
Y = X(:,rtree.Nodes.Gs(inl));
Rti = [rtree.Nodes.Rti(inl,:)]';
Yii = LAF.apply_rigid_xforms(Y,Rti);

figure;
LAF.draw(gca,Yii);

keyboard;

%cfg.dr = [];
%cfg.grouping = 'G_u';
%[cfg,leftover] = cmp_argparse(cfg,varargin{:});
%
%invH = inv(model.Hinf);
%
%y_ii = LAF.apply_rigid_xforms(model.U(:,corresp.G_u), ...
%                              model.Rt_i(:,corresp.G_i));
%y_jj = LAF.apply_rigid_xforms(y_ii,[model.Rt_ij(:,corresp.G_ij)]);
%
%y_ii = LAF.rd_div(LAF.renormI(blkdiag(invH,invH,invH)*y_ii), ...
%                  model.cc,model.q);
%y_jj = LAF.rd_div(LAF.renormI(blkdiag(invH,invH,invH)*y_jj), ...
%                  model.cc,model.q);
%
%LAF.draw_groups(ax,y_ii,corresp.(cfg.grouping)');
%LAF.draw_groups(ax,y_jj,corresp.(cfg.grouping)');
%
%if ~isempty(cfg.dr)
%    vi = [cfg.dr(:,corresp.i').u];
%    LAF.draw_groups(ax,vi,corresp.(cfg.grouping)', ...
%                    'Color','w','LineWidth',1, ...
%                    'LineStyle','-',leftover{:});
%    vj = [cfg.dr(:,corresp.j').u];
%    LAF.draw_groups(ax,vj,corresp.(cfg.grouping)',...
%                    'Color','w','LineWidth',1, ...
%                    'LineStyle','-',leftover{:});
%end
