function draw(ax1,msers,varargin)
hold on;
colors = varycolor(size(msers.rle,2));
for k = 1:size(msers.rle,2)
    pts = msers.rle{3,k};
    if iscell(pts)
    	pts = pts{1};
    end
    plot(ax1,pts(1,:) + 0.5,pts(2,:) + 0.5,varargin{:});
end
axis ij;
axis equal;
hold off;