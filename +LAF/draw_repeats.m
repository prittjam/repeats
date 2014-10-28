function draw_repeats(ax0,u,labels,varargin)
ulabels = unique(labels);
cfg.topN = [];
cfg.exclude = 0;

[cfg,leftover] = helpers.vl_argparse(cfg,varargin{:});

if isempty(leftover)
    leftover = {'LineWidth',3};
end

uinlier_labels = setdiff(ulabels,cfg.exclude);

if isempty(cfg.topN)
    cfg.topN = numel(uinlier_labels);
end

mpdc = distinguishable_colors(cfg.topN);
minul = min(ulabels);
count = hist(labels,minul:max(ulabels));
[~,ind] = sort(count(uinlier_labels-minul+1),'descend');

jj = 1;
for k = 1:cfg.topN
    ind2 = find(labels == uinlier_labels(ind(k)));
    LAF.draw(ax0,u(:,ind2),'Color',mpdc(jj,:),leftover{:});
    jj = jj+1;
end
