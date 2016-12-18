function [] = draw_groups(ax0,u,G,varargin)
cfg.exclude = [];
cfg.linewidth = 3;
cfg.printlabels = true;
cfg.color = '';
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

Lia = ismember(G,cfg.exclude);
G(find(Lia)) = nan;
[G,uG] = findgroups(G);

cmap_dc = distinguishable_colors(numel(uG)+1);
colors = zeros(numel(G),3);
colors(G>0,:) = cmap_dc(G(G>0),:);

cmp_splitapply(@(v,color) draw_one_group(ax0,v,color,cfg.linewidth,leftover), ...
               u,colors',G);

if cfg.printlabels
    cmp_splitapply(@(u,id,color) print_group_labels(ax0,u,id,color), ...
                   u,colors',G,G);
end

function [] = draw_one_group(ax0,u,color,linewidth,leftover)
LAF.draw(ax0,u,'Color','black', ...
         'LineWidth',linewidth+2, ...
         leftover{:});
su = LAF.shrink(u,1.5);
LAF.draw(ax0,su,'Color',color(:,1), ...
         'LineWidth',linewidth, ...
         leftover{:});

function [] = print_group_labels(ax0,u,color,id)
mu = [(u(1:2,:)+u(4:5,:)+u(7:8,:))/3];
text(mu(1,:)',mu(2,:)',num2str(id(1)),'Color',color(:,1));