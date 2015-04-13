function draw_repeats(ax0,u,labeling,varargin)
ulabeling = unique(labeling);
cfg.topN = [];
cfg.exclude = 0;

[cfg,leftover] = helpers.vl_argparse(cfg,varargin{:});

if isempty(leftover)
    leftover = {'LineWidth',3};
end

udraw_labeling = setdiff(ulabeling,cfg.exclude);

if isempty(cfg.topN)
    cfg.topN = numel(udraw_labeling);
end

mpdc = distinguishable_colors(cfg.topN);
minul = min(ulabeling);
count = hist(labeling,[minul:max(ulabeling)+1]);
[~,ind] = sort(count(udraw_labeling-minul+1),'descend');

jj = 1;
for k = 1:cfg.topN
    ind2 = find(labeling == udraw_labeling(ind(k)));
    LAF.draw(ax0,u(:,ind2),'Color',mpdc(jj,:),leftover{:});
    text(u(4,ind2)'+5,u(5,ind2)'+5,num2str(udraw_labeling(ind(k))),'Color',mpdc(jj,:));
    jj = jj+1;
end