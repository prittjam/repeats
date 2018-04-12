function [] = draw_groups(ax0,segments,labeling,varargin)
cfg.exclude = 0;
cfg.color = '';
[cfg,leftover] = cmp_argparse(cfg,varargin{:});
if isempty(leftover)
    leftover = {'LineWidth',3};
end

ulabeling = unique(labeling);
udraw_labeling = setdiff(ulabeling,cfg.exclude);
mpdc = distinguishable_colors(max(udraw_labeling)+1);
cmap = [0:max(udraw_labeling)];

for k = 1:numel(udraw_labeling)
    idx = reshape(find(labeling == udraw_labeling(k)),1,[]);
    color = mpdc(find(cmap==udraw_labeling(k)),:);
    if ~isempty(cfg.color)
    	color = cfg.color;
    end
    SPIXEL.draw_boundaries(gca,segments, ...
                           'Color',color,'Segments',idx);
end