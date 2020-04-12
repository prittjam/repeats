function draw(ax, c, varargin)
    % draws a circle c = [xc...; yc...; r...]
    num_pts = 500;

    t = linspace(0, 1, num_pts);
    N = size(c,2);
    colormap(hsv(N))
    cmap = colormap;
    for k=1:N
        cx = c(1,k);
        cy = c(2,k);
        R = c(3,k);
        phi = t .* 2 * pi;
        pts = [cx + R .* cos(phi);...
               cy + R .* sin(phi);...
               ones(1, num_pts)];
        hold on
        if any(strcmpi('color',varargin))
            plot(ax, pts(1,:), pts(2,:), varargin{:});
        else
            plot(ax, pts(1,:), pts(2,:), "Color", cmap(k,:), varargin{:});
        end
    end
end