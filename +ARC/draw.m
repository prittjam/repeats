function draw(ax, arcs, varargin)
    % arcs -- {3 x arc_length} x num_arcs
    colormap(hsv(numel(arcs)))
    cmap = colormap;
    for k=1:numel(arcs)
        hold on
        if any(strcmpi('color',varargin))
            plot(ax, arcs{k}(1,:), arcs{k}(2,:), varargin{:});
        else
            plot(ax, arcs{k}(1,:), arcs{k}(2,:), "Color", cmap(k,:), varargin{:});
        end
    end
    hold off;