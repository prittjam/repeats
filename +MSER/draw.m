function draw(ax1,msers,varargin)
hold on;
colors = varycolor(size(msers.rle,2));
for k = 1:size(msers.rle,2)
    m = msers.rle{1,k};
    pts = m{1};
    plot(ax1,pts(1,:)+0.5,pts(2,:)+0.5,varargin{:});
end

axis ij;
axis equal;
hold off;