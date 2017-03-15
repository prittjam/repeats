function [] = draw_reconstruction(ax,corresp,model,varargin)
cfg.dr = [];
cfg.grouping = 'G_u';
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

invH = inv(model.Hinf);

y_ii = LAF.apply_rigid_xforms(model.U(:,corresp.G_u), ...
                              model.Rt_i(:,corresp.G_i));
y_jj = LAF.apply_rigid_xforms(y_ii,[model.Rt_ij(:,corresp.G_ij)]);

y_ii = LAF.renormI(blkdiag(invH,invH,invH)*y_ii);
y_jj = LAF.renormI(blkdiag(invH,invH,invH)*y_jj);

LAF.draw_groups(ax,y_ii,corresp.(cfg.grouping)');
LAF.draw_groups(ax,y_jj,corresp.(cfg.grouping)');

if ~isempty(cfg.dr)
    vi = [cfg.dr(:,corresp.i').u];
    LAF.draw_groups(ax,vi,corresp.(cfg.grouping)', ...
                    'Color','w','LineWidth',3, ...
                    'LineStyle','--',leftover{:});
    vj = [cfg.dr(:,corresp.j').u];
    LAF.draw_groups(ax,vj,corresp.(cfg.grouping)',...
                    'Color','w','LineWidth',3, ...
                    'LineStyle','--',leftover{:});
end
