function draw(ax1,msers,varargin)
hold on;
colors = varycolor(size(msers.rle,2));
for k = 1:size(msers.rle,2)
    pts = msers.rle{3,k} + 0.5;
    plot(ax1,pts(1,:),pts(2,:),varargin{:});
end
axis ij;
axis equal;
hold off;