function [] = draw_lafs(ax1,visual,color)
axes(ax1);

if isempty(visual)
    return;
end

if nargin < 3
    color = repmat([204/255 85/255 0],numel(visual),1);
end

if size(color,1) == 1
    color = repmat(color,numel(visual),1);
end

axis ij;

num_visuals = length(visual);
h = zeros(1, num_visuals);
% we assume that all DRs can be visualised as polygons - yet
hold on;

for l=1:num_visuals
    h(l)=plot(visual(l).poly(1,:), visual(l).poly(2,:)); 
    set(h(l), ...
        'Color', color(l,:), ...
        'LineWidth', 2);
    hp = scatter(visual(l).poly(1,:), ...
                 visual(l).poly(2,:));
    set(get(hp,'Children'), ... 
        'LineWidth', 1,'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', color(l,:), ...
        'MarkerFaceColor' , [.75 .75 1]);

    hp2 = scatter(visual(l).poly(1,1),visual(l).poly(2,1));

    set(get(hp2,'Children'), ... 
        'LineWidth', 1,'Marker', 'o', ...
        'MarkerSize', 4, 'MarkerEdgeColor', color(l,:), ...
        'MarkerFaceColor' , [0.1 0.1 0.2]);
    
end
axis equal;
hold off;