function [] = draw_reconstruction(ax,u_corr,model,varargin)
cfg.dr = [];
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

invH = inv(model.Hinf);

y_ii = LAF.apply_rigid_xforms(model.U(:,u_corr.G_u), ...
                              model.Rt_i(:,u_corr.G_i));
y_jj = LAF.apply_rigid_xforms(y_ii,[model.Rt_ij(:,u_corr.G_ij)]);

y_ii = LAF.renormI(blkdiag(invH,invH,invH)*y_ii);
y_jj = LAF.renormI(blkdiag(invH,invH,invH)*y_jj);

LAF.draw_groups(ax,y_ii,u_corr.G_ij');
LAF.draw_groups(ax,y_jj,u_corr.G_ij');

if ~isempty(cfg.dr)
    vi = [cfg.dr(:,u_corr.i').u];
    LAF.draw_groups(gca,vi,u_corr.G_ij', ...
                    'Color','w','LineWidth',3, ...
                    'LineStyle','--',leftover{:});
    vj = [cfg.dr(:,u_corr.j').u];
    LAF.draw_groups(gca,vj,u_corr.G_ij',...
                    'Color','w','LineWidth',3, ...
                    'LineStyle','--',leftover{:});
end

%k2 = 0;
%M = height(res.u_corr);
%MM = max([M 9]);
%
%uind = unique(res.u_corr{:,'G_ij'});
%
%for k = uind'
%    idx = find(res.u_corr{:,'G_ij'} == k);

%    LAF.draw(gca,y_ii(:,idx),'LineWidth',3,'LineStyle','--', ...
%             'Color','w');

%    LAF.draw(gca,y_jj(:,idx),'LineWidth',3,'LineStyle','--', ...
%             'Color','w');
%end
%
%LAF.draw_groups(gca,y_ii,res.u_corr{:,'G_rt'}','LineStyle','--');
%LAF.draw_groups(gca,y_jj,res.u_corr{:,'G_rt'}','LineStyle','--');

%keyboard;
%
%imshow(img);
%LAF.draw_groups(gca,u(:,res.u_corr{:,'i'}),res.u_corr{:,'G_u'}');
%LAF.draw_groups(gca,u(:,res.u_corr{:,'j'}),res.u_corr{:,'G_u'}');
%
%%LAF.draw_groups(gca,y_ii,res.u_corr{:,'G_rt'}','LineStyle','--');
%%LAF.draw_groups(gca,y_jj,res.u_corr {:,'G_rt'}','LineStyle','--');
%%
%keyboard;
%
%
%
%LAF.draw(gca,y_ii(:,ind));
%LAF.draw(gca,y_jj(:,ind));
