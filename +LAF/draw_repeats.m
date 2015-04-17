function draw_repeats(ax0,u,labeling,varargin)
cfg.exclude = 0;
[cfg,leftover] = helpers.vl_argparse(cfg,varargin{:});
if isempty(leftover)
    leftover = {'LineWidth',3};
end

ulabeling = unique(labeling);
udraw_labeling = setdiff(ulabeling,cfg.exclude);
mpdc = distinguishable_colors(numel(udraw_labeling));

mu = [(u(1:2,:)+u(4:5,:)+u(7:8,:))/3];

for k = 1:numel(udraw_labeling)
    idx = find(labeling == udraw_labeling(k));
    LAF.draw(ax0,u(:,idx),'Color',mpdc(k,:), ...
             leftover{:});
    text(mu(1,idx)',mu(2,idx)', ...
         num2str(udraw_labeling(k)), 'Color',mpdc(k,:));
end