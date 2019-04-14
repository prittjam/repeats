function [] = make_feasibility_figs(src_path,target_path,colormap)
repeats_init();
axis_options = {'enlargelimits=false'};  
sensitivity = load(src_path);
is_legend_on = 'Off';

res = sensitivity.res(:,{'solver','num_real','num_feasible'});                   
solver_list = {'$\mH22\vl$', ...
               '$\mH222\vl\lambda$', ...
               '$\mH32\vl\lambda$', ...
               '$\mH4\vl\lambda$', ...
               '$\mH^{\prime}222\vl\lambda$'};

Lia = ismember(res.solver,solver_list);

edges = [1:2:34];
edges2 = [0:5];
real_histcount_list = zeros(numel(solver_list),numel(edges)-1);
feas_histcount_list = zeros(numel(solver_list),numel(edges2)-1);

solver_str = cellstr(res.solver);

for k = 1:numel(solver_list)
    ind = strcmpi(solver_str,solver_list{k});
    tmp = res(ind,:);
    nr = reshape([tmp.num_real],1,[]);
    real_histcount_list(k,:) = histcounts(nr(:),edges);
    nf = reshape([tmp.num_feasible],1,[]);
    feas_histcount_list(k,:) = histcounts(nf(:),edges2);
end

color_list = zeros(numel(solver_list),3);
for k = 1:numel(solver_list)
    color_list(k,:) = colormap(solver_list{k});
end

figure;
b1 = bar(edges(1:end-1)', ...
         real_histcount_list', ...
         'CData',color_list);
for k = 1:numel(b1)
    b1(k).FaceColor = color_list(k,:);
end
set(gca,'YScale','log');
xticks(0:5:30);
xlabel('Number of Real Solutions')
ylabel('Frequency (7500 trials)');

matlab2tikz([target_path 'real_solutions.tikz'], ...
            'width', '\fwidth','extraAxisOptions',axis_options);

figure;
b2 = bar(edges2(1:end-1)', ...
         feas_histcount_list', ...
         'CData',color_list);
for k = 1:numel(b2)
    b2(k).FaceColor = color_list(k,:);
end
set(gca,'YScale','log');
xlabel('Number of Feasible Solutions')
ylabel('Frequency (7500 trials)');

matlab2tikz([target_path 'feasible_solutions.tikz'], ...
            'width', '\fwidth','extraAxisOptions',axis_options);