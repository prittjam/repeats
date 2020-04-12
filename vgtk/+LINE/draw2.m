function draw(ax, l, varargin)
    % WIP
    N = size(l,2);
    colormap(hsv(N))
    cmap = colormap;
    for k=1:N
        pts = [cx + R .* cos(phi);...
               cy + R .* sin(phi);...
               ones(1, num_pts)];
        hold on
        if any(strcmpi('color',varargin))
            lh = line(reshape(pts2(1,:), 2, []),...
                      reshape(pts2(2,:), 2, []), varargin{:});
            % plot(ax, pts(1,:), pts(2,:), varargin{:});
        else
            lh = line(reshape(pts2(1,:),2,[]),...
                      reshape(pts2(2,:),2,[]),...
                      "Color", cmap(k,:), varargin{:});
            % plot(ax, pts(1,:), pts(2,:), "Color", cmap(k,:), varargin{:});
        end
        hold off;
        set(lh, 'LineWidth', 1.75);
    end
end