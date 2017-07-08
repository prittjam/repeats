function hboxes = make_grouped_boxplot(res,solver_list,field_name,group_name,varargin)
cfg.ylim = [];
cfg = cmp_argparse(cfg,varargin{:});

for k1 = 1:numel(solver_list)
    solver_ind = find(ismember(res.solver,solver_list{k1}));
    res2 = res(solver_ind,:);
    [g,usigma] = findgroups(res2.(group_name));
    ug = unique(g);
    x_strings = arrayfun(@(x) num2str(x), usigma, ...
                         'UniformOutput',false);        
    ind = reshape(1:numel(ug)*(numel(solver_list)+1), ...
                  numel(solver_list)+1,[]);
    res3 = cmp_splitapply(@(x) { x },res2.(field_name),g);
    data_groups(:,ind(k1+1,:)) = [res3{:}];
end

data_groups(:,ind(1,:)) = nan;
data_groups = [data_groups nan(size(data_groups,1),1)];
    
grouped_labels = x_strings;
part_ind = find(all(isnan(data_groups))); 
data_ind = find(any(~isnan(data_groups)));
num_items = numel(solver_list);

colors = distinguishable_colors(num_items);
colors = [colors;1 1 1];
colors = repmat(colors,numel(x_strings),1);
colors = [1 1 1;colors];

figure;
xlim([0 size(data_groups,2)]);

ax = gca;
boxplot(ax,data_groups, ...
        'colors',colors, ...
        'Symbol','+');
ylim(cfg.ylim);

bounds = axis;
hold on;
for k = part_ind(2:end-1)
    line([k k],[bounds(3) bounds(4)],'Color','0.8 0.8 0.8');
end
hold off;

xticks(mean(reshape(data_ind,num_items,[]),1));
xticklabels(grouped_labels);

boxes = findobj(gcf, 'Tag', 'Box');
hboxes = boxes(end-1:-1:(end-1-num_items+1));

axes(ax);
