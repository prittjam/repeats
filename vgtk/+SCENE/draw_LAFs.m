function draw_LAFs(X, Gapp, varargin)
    cfg = struct('fig_path', 'none');
    cfg = cmp_argparse(cfg, varargin{:});
    if strcmp(cfg.fig_path, 'none')
        figure
    else
        f = figure('visible','off');
    end
    
    % xlim([-5000 5000]);
    % ylim([-5000 5000]);
    axis ij equal
    cmap = lines(max(Gapp));
    for k = 1:max(Gapp)
        LAF.draw(gca, X(:,Gapp==k), 'Color', cmap(k,:), 'LineWidth', 1.5);
    end

    if ~strcmp(cfg.fig_path, 'none')
        saveas(f, cfg.fig_path);
    end
end