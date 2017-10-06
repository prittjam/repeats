function main_ax = make_grouped_boxplot(res,data_field,group_list,varargin)
cfg.ylim = [];
cfg.xlabel = [];
cfg.ylabel = [];
cfg.truth = [];
cfg.yticks = [];
cfg.location = [];

cfg = cmp_argparse(cfg,varargin{:});

item_names = arrayfun(@(x) [char(x)], ...
                      unique(res.(group_list{end})), ...
                      'UniformOutput',false);

for k = 1:numel(group_list)
    group_field = group_list{k};
    [G{k},uval{k}] = findgroups(res.(group_field));
    
    if iscategorical(uval{k})
        uval{k} = grp2idx(uval{k});
        res.(group_field) = grp2idx(res.(group_field));
    end
end

num_categories = numel(uval{1});
num_groups = numel(uval{2});

colors = distinguishable_colors(num_groups);

groups = allcomb(uval{:});
for k1 = 1:size(groups,1)
    in = ismember(res{:,{group_list{:}}}, ...
                  groups(k1,:),'Rows');
    ind = find(in);
    data(:,k1) = res{ind,data_field};
end


figure('Color',[1 1 1],'Position',[178 457 1400 521]);

main_ax = axes; % create a temporary axes
set(main_ax,'XColor','w','YColor','w','TickDir','out')
xrule = main_ax.XAxis;
xrule.FontSize = 14;
xlabel(main_ax,'Noise', ...
       'Interpreter','Latex', ...
       'Color','k'); 

% we get the measurements of the plotting area:
pos = main_ax.Position;
% and divide it to our data:
width = pos(3)/num_categories; % the width of each group
% the bottom left corner of each group:
corner = linspace(pos(1),pos(3)+pos(1),num_categories+1);

categories = uval{1};

for k = 1:num_categories
    ax = axes;
    boxplot(ax,data(:,num_groups*(k-1)+1:(num_groups)*k), ...
            'Colors', repmat(colors,num_groups,1), ...
            'Symbol','k+');
    ax.XTick = mean(reshape(1:num_groups,2,[]));
    ax.XTickLabel = num2str(categories(k)); 
    xrule = ax.XAxis;
    xrule.FontSize = 14;

    % set the ylim to include all data:
    if ~isempty(cfg.ylim)
        ax.YLim = cfg.ylim;
    end
    
    box off
    
    if k == 1
        ylabel(cfg.ylabel,'Interpreter','Latex');
        yticks(cfg.yticks);
        tickstr = arrayfun(@(x) num2str(x), cfg.yticks, ...
                           'UniformOutput',false);
        yticklabels(tickstr);
        yrule = ax.YAxis;
        yrule.FontSize = 14;
    else
        ax.YTick = [];
    end

    ax.Position = [corner(k) 0.125 width 0.775];

    if ~isempty(cfg.truth)
        hold on;
        bounds = axis;
        line([bounds(1) bounds(2)],[cfg.truth cfg.truth],'Color','c');
        hold off;
    end

    if k == 1
        boxes = flipud(findobj(gca, 'Tag', 'Box'));
        tmp = boxes(1:numel(boxes));
        leg1 = legend(tmp, item_names{:}, ...
                      'Location',cfg.location);
        set(leg1, 'FontSize', 12);
        set(leg1,'Interpreter','Latex');
    end
end

%axis off
