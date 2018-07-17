function ax = make_grouped_boxplot(res,data_field,group_list,varargin)
cfg.ylim = [];
cfg.xlabel = [];
cfg.ylabel = [];
cfg.truth = [];
cfg.yticks = [];
cfg.location = [];
cfg.colors = [];
cfg.symbol = 'k';
cfg.legend = 'On';

cfg = cmp_argparse(cfg,varargin{:});

group_names = arrayfun(@(x) [char(x)], ...
                       unique(res.(group_list{end})), ...
                       'UniformOutput',false);

for k = 1:numel(group_list)
    group_field = group_list{k};
    [~,uval{k}] = findgroups(res.(group_field));
    if iscategorical(uval{k})
        uval{k} = grp2idx(uval{k});
        res.(group_field) = grp2idx(res.(group_field));
    end
end

categories = uval{1};
num_categories = numel(uval{1});
num_groups = numel(uval{2});

if isempty(cfg.colors)
    cfg.colors = distinguishable_colors(num_groups);
end

groups = allcomb(uval{:});
k2 = 0;
for k1 = 1:size(groups,1)
    in = all(ismember(res{:,{group_list{:}}}, groups(k1,:),'Rows'),2);
    ind = find(in);
    if ~isempty(ind)
        k2 = k2+1;
        data(:,k2) = res{ind,data_field};
    end
end

figure;
ax = axes; % create a temporary axes
set(ax,'fontsize',6);
boxplot(ax,data, 'Colors', cfg.colors, ...
        'Symbol',cfg.symbol);

xticks((0:num_categories-1)*(num_groups)+(num_groups+1)/2);

if isnumeric(categories)
    xticklabels(num2str(categories));
else
    xticklabels(categories);
end

xlabel(ax,'Noise ($\sigma$) [pixels]', ...
       'Interpreter','Latex','Color','k'); 
ylabel(cfg.ylabel,'Interpreter','Latex');
ylim(cfg.ylim);
yticks(cfg.yticks);
tickstr = arrayfun(@(x) num2str(x), cfg.yticks, ...
                   'UniformOutput',false);
yticklabels(tickstr);

bounds = axis;
if ~isempty(cfg.truth)
    line([bounds(1) bounds(2)], ...
         [cfg.truth cfg.truth],'Color',[0.3 0.3 0.3], 'LineStyle','--');
end

x = (1:num_categories-1)*(num_groups)+0.5;
xx = [x;x];
yy = [repmat(bounds(3),1,num_categories-1); ...
      repmat(bounds(4),1,num_categories-1)];
line(xx,yy,'Color',[0.8 0.8 0.8]);

axis square;
pbaspect([16 9 1]);

if strcmpi(cfg.legend,'on')
    boxes = flipud(findobj(gca, 'Tag', 'Box'));
    tmp = boxes(1:numel(boxes));
    legend('boxoff');
    leg1 = legend(tmp(1:num_groups), ...
              group_names{:}, ...
              'Location',cfg.location);
    set(leg1, 'FontSize', 10);
    set(leg1,'Interpreter','Latex');
else
    legend('off');
end

