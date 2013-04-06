function draw2d_repeated_lafs(ax0,u,vis,varargin)

colors = varycolor(size(vis,2));
for j = 1:size(vis,2)
    draw2d_lafs(ax0,u(:,nonzeros(vis(:,j))), ...
                'Color',colors(j,:), ...
                varargin{:});
end