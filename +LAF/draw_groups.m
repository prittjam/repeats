function draw_repeats(ax0,u,labeling,varargin)
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

mu = [(u(1:2,:)+u(4:5,:)+u(7:8,:))/3];

for k = 1:numel(udraw_labeling)
    idx = find(labeling == udraw_labeling(k));
    color = mpdc(find(cmap==udraw_labeling(k)),:);
    if ~isempty(cfg.color)
    	color = cfg.color;
    end
    LAF.draw(ax0,u(:,idx),'Color',color,leftover{:});
    if numel(unique(labeling)) > 1
        text(mu(1,idx)',mu(2,idx)', ...
             num2str(udraw_labeling(k)), ...
             'Color',color);
    end
end