function [] = draw2d_lafs(ax1,u,varargin)
axes(ax1);

x = reshape(u(1:3:end,:),3,[]);
y = reshape(u(2:3:end,:),3,[]);

hold on;

if isempty(varargin)
    plot(x,y); 
end

hp = scatter(x(:),y(:));
hp2 = scatter(x(1:4:end), ...
              y(1:4:end));
hold off;

set(get(hp,'Children'), ... 
    'LineWidth', 1,'Marker', 'o', ...
    'MarkerSize', 2,  ...
    'MarkerFaceColor' , [.75 .75 1]);

set(get(hp2,'Children'),           ...
  'LineWidth'       , 1           , ...
  'Marker'          , 'o'         , ...
  'MarkerSize'      , 4           , ...
  'MarkerEdgeColor' , [.2 .2 .2]  , ...
  'MarkerFaceColor' , [.7 .7 .7]  );

axis ij;
axis equal;