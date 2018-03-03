function [] = draw2d_repeated_lafs_xform(ax1,u,vis,xform)
[~,jj] = find(vis);
jj3 = [jj jj jj]';
jj3 = jj3(:);

tmp = get(ax1,'ColorOrder');
cmap = colormap(ax1,'lines');

set(ax1,'ColorOrder', cmap(jj,:));

vx = reshape(u(1:3:end,vis(find(vis))), ...
             3,[]);
vy = reshape(u(2:3:end,vis(find(vis))), ...
             3,[]);

t = [0:0.1:1]';

wx = [bsxfun(@plus,vx(1,:),bsxfun(@times,t,vx(2,:)-vx(1,:))); ...
      bsxfun(@plus,vx(2,:),bsxfun(@times,t,vx(3,:)-vx(2,:)))];

wy = [bsxfun(@plus,vy(1,:),bsxfun(@times,t,vy(2,:)-vy(1,:)));...
      bsxfun(@plus,vy(2,:),bsxfun(@times,t,vy(3,:)-vy(2,:)))];
ud = tformfwd(xform, [wx(:) wy(:) ones(numel(wx),1)]);

x = reshape(ud(:,1),2*numel(t),[]);
y = reshape(ud(:,2),2*numel(t),[]);

hold on;
plot(x,y);
scatter(x(numel(t)+1:2*numel(t):end), ...
        y(numel(t)+1:2*numel(t):end), ...
        10,'k','filled');
scatter(x(2*numel(t)+1:2*numel(t):end), ...
        y(2*numel(t)+1:2*numel(t):end), ...
        10,'k','filled');
hp = scatter(x(1:2*numel(t):end), ...
             y(1:2*numel(t):end));
hold off;

set(get(hp,'Children'),           ...
  'LineWidth'       , 1           , ...
  'Marker'          , 'o'         , ...
  'MarkerSize'      , 4           , ...
  'MarkerEdgeColor' , [.2 .2 .2]  , ...
  'MarkerFaceColor' , [.7 .7 .7]  );

set(ax1,'ColorOrder', tmp);