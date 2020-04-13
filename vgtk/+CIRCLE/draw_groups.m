function [] = draw_groups(ax,c,G,varargin)

if iscell(G)
    for k=1:numel(G)
        G_temp(G{k}) = k;
    end
    G = G_temp;
end

[G,uG] = findgroups(G);
cmap_dc = distinguishable_colors(numel(uG)+1);
colors = zeros(numel(G),3);
colors(G>0,:) = cmap_dc(G(G>0),:);

cmp_splitapply(@(v,color) ...
               CIRCLE.draw(ax,v,'Color',color(:,1),varargin{:}),...
               c,colors',G);