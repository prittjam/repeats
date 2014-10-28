function draw2d_laf_labels(ax0,u,labels,varargin)
ulabels = unique(labels);
cfg.topN = [];
cfg.exclude_labels = [];
cfg.draw_labels = false;

[cfg,leftover] = helpers.vl_argparse(cfg,varargin{:});

if isempty(leftover)
    leftover = {'LineWidth',3};
end

uinlier_labels = setdiff(ulabels,cfg.exclude_labels);

if isempty(cfg.topN)
    cfg.topN = numel(uinlier_labels);
end

colors = varycolor(cfg.topN);
count = hist(labels,1:max(ulabels));
[~,ind] = sort(count(uinlier_labels),'descend');

jj = 1;
for k = 1:cfg.topN
    ind2 = find(labels == uinlier_labels(ind(k)));
    draw2d_lafs(ax0,u(:,ind2),'Color',colors(jj,:), ...
                leftover{:});

    if cfg.draw_labels
        for k2 = 1:numel(ind2)
            x = u(4,ind2(k2));
            y = u(5,ind2(k2));
            text(x,y,num2str(labels(ind2(k2))),'Color',colors(jj,:));
        end
    end

    jj = jj+1;
end