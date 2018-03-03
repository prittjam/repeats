function [] = draw_groups(ax0,u,G,varargin)
cfg.exclude = [];
cfg.printlabels = false;
cfg.linewidth = 3;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

if isstruct(u)
    u = [u(:).u];
end

Lia = ismember(G,cfg.exclude);
G(find(Lia)) = nan;
[G,uG] = findgroups(G);

cmap_dc = distinguishable_colors(numel(uG)+1);
colors = zeros(numel(G),3);
colors(G>0,:) = cmap_dc(G(G>0),:);

if isempty(leftover)
    cmp_splitapply(@(v,color) ...
                   draw_one_group(ax0,v,color,cfg.linewidth),...
                   u,colors',G);
else
    cmp_splitapply(@(v,color) ...
                   draw_one_group(ax0,v,color,cfg.linewidth,leftover{:}),...
                   u,colors',G);
end

if cfg.printlabels
    cmp_splitapply(@(u,color,id) print_group_labels(ax0,u,color,id), ...
                   u,colors',G,G);
end

function [] = draw_one_group(ax0,u,color,linewidth,varargin)
LAF.draw(ax0,u,'Color','black', 'LineWidth',linewidth+2,varargin{:});
su = LAF.shrink(u,1.5);
LAF.draw(ax0,su,'Color',color(:,1),'LineWidth',linewidth,varargin{:});

function [] = print_group_labels(ax0,u,color,id)
mu = [(u(1:2,:)+u(4:5,:)+u(7:8,:))/3];
text(ax0,mu(1,:)',mu(2,:)',num2str(id(1)),'Color',color(:,1));
