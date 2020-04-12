function draw_clusters(x, Gapp, c, arcs, Gvpc, varargin)
    cfg = struct('fig_path', 'none');
    cfg = cmp_argparse(cfg, varargin{:});
    if strcmp(cfg.fig_path, 'none')
        figure
    else
        f = figure('visible','off');
    end

    axis ij equal off
    xlim([0 1000]);
    ylim([0 1000]);
    cmap = lines(max(Gapp));
    for k = 1:max(Gapp)
        LAF.draw(gca, x(:,Gapp==k), 'Color', cmap(k,:), 'LineWidth', 1.5);
    end
    CIRCLE.draw(gca,c(1:3,Gvpc==1), 'Color', 'm', 'LineWidth', 1.75, 'LineStyle', ':');
    CIRCLE.draw(gca,c(1:3,Gvpc==2), 'Color', 'g', 'LineWidth', 1.75, 'LineStyle', ':');
    ARC.draw(gca,arcs(:,Gvpc==1),'Color', 'm', 'LineWidth',1.5);
    ARC.draw(gca,arcs(:,Gvpc==2),'Color', 'g', 'LineWidth',1.5);
    
    if ~strcmp(cfg.fig_path, 'none')
        saveas(f, cfg.fig_path);
    end
end