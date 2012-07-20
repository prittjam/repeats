function draw2d_piecewise_linear_repeated_lafs(ax1,x,y,vis,line_style)
iv = nonzeros(vis');
[ii,jj] = find(vis');
color_set = repmat(varycolor(size(vis,2)),size(vis,1),1);
idx = sub2ind(size(vis'),ii,jj);
draw2d_piecewise_linear_lafs(ax1,x(:,iv),y(:,iv),'-',...
                             color_set(idx,:));