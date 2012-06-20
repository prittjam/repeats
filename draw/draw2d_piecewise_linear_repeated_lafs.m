function draw2d_piecewise_linear_repeated_lafs(ax1,x,y,vis)
[ii,jj] = find(vis);

iv = nonzeros(vis);

tmp = get(ax1,'ColorOrder');
cmap = colormap(ax1,'lines');
cmap = cmap(jj,:);

draw2d_piecewise_linear_lafs(ax1,x(:,iv),y(:,iv),cmap);