function draw2d_repeated_lafs(ax1,u,vis,line_style)

if nargin < 4
    line_style = '-o';
end

iv = nonzeros(vis');
[ii,jj] = find(vis');
color_set = repmat(varycolor(size(vis,2)),size(vis,1),1);
idx = sub2ind(size(vis'),ii,jj);

tmp = get(gca,'ColorOrder');
set(gca,'ColorOrder',color_set(idx,:));

x = reshape(u(1:3:end,iv),3,[]);
y = reshape(u(2:3:end,iv),3,[]);

hold on;
h1 = plot(x,y,line_style, ...
          'LineWidth'       , 2, ...
          'MarkerEdgeColor','k', ...
          'MarkerFaceColor',[.49 1 .63], ...
          'MarkerSize',4);

plot(x(1:3:end)',y(1:3:end)','o', ...
     'LineWidth'       , 2, ...
     'MarkerEdgeColor','k', ...
     'MarkerFaceColor',[0.43 0.81 0.96], ...
     'MarkerSize',5);
hold off;

set(gca,'ColorOrder', tmp);