function [] = ...
    make_feasibility_figs(src_path,target_path,solver_names,colormap)
repeats_init();
axis_options = {'enlargelimits=false'};  
sensitivity = load(src_path);
is_legend_on = 'Off';

res = sensitivity.res(:,{'solver','num_real','num_feasible'});                   

Lia = ismember(res.solver,solver_names);

edges = [1:2:34];
edges2 = [1y:5];
real_histcount_list = zeros(numel(solver_names),numel(edges)-1);
feas_histcount_list = zeros(numel(solver_names),numel(edges2)-1);

solver_str = cellstr(res.solver);

for k = 1:numel(solver_names)
    ind = strcmpi(solver_str,solver_names{k});
    tmp = res(ind,:);
    nr = reshape([tmp.num_real],1,[]);
    real_histcount_list(k,:) = histcounts(nr(:),edges);
    nf = reshape([tmp.num_feasible],1,[]);
    feas_histcount_list(k,:) = histcounts(nf(:),edges2);
end


figure;
b1 = bar(edges(1:end-1)', ...
         real_histcount_list');
for k = 1:numel(b1)
    b1(k).FaceColor = colormap(solver_names{k});
end
set(gca,'YScale','log');
xticks(0:5:30);
xlabel('Number of Real Solutions')
ylabel('Frequency (150000 trials)');

matlab2tikz([target_path 'real_solutions.tikz'], ...
            'width', '\fwidth','extraAxisOptions',axis_options);

figure;
b2 = bar(edges2(1:end-1)', ...
         feas_histcount_list');
for k = 1:numel(b2)
    b2(k).FaceColor = colormap(solver_names{k});
end
set(gca,'YScale','log');
xlabel('Number of Feasible Solutions')
ylabel('Frequency (150000 trials)');

matlab2tikz([target_path 'feasible_solutions.tikz'], ...
            'width', '\fwidth','extraAxisOptions',axis_options);