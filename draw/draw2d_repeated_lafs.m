function draw2d_repeated_lafs(ax1,u,vis)
[~,jj] = find(vis);
jj3 = [jj jj jj]';
jj3 = jj3(:);

tmp = get(ax1,'ColorOrder');
cmap = colormap(ax1,'lines');

set(ax1,'ColorOrder', cmap(jj,:));

x = reshape(u(1:3:end,vis(find(vis))), ...
            3,[]);
y = reshape(u(2:3:end,vis(find(vis))), ...
            3,[]);

hold on;
plot(x,y);
hp = scatter(x(:),y(:),10,cmap(jj3,:),'filled');
hp2 = scatter(x(1:3:end), ...
              y(1:3:end));
hold off;

set(get(hp2,'Children'),           ...
  'LineWidth'       , 1           , ...
  'Marker'          , 'o'         , ...
  'MarkerSize'      , 4           , ...
  'MarkerEdgeColor' , [.2 .2 .2]  , ...
  'MarkerFaceColor' , [.7 .7 .7]  );

set(ax1,'ColorOrder', tmp);

