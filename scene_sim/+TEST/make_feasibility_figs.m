function [] = ...
    make_feasibility_figs(src_path,target_path,solver_names,colormap)
repeats_init();
axis_options = {'enlargelimits=false'};  
sensitivity = load(src_path);
is_legend_on = 'Off';

res = sensitivity.res(:,{'solver','num_real','num_feasible'});                   

Lia = ismember(res.solver,solver_names);

edges = [1:2:34];
edges2 = [1:4];
real_histcount_list = zeros(numel(solver_names),numel(edges)-1);
feas_histcount_list = zeros(numel(solver_names),numel(edges2)-1);

solver_str = cellstr(res.solver);
longreal=[];

remapit = [1 5 6 7 2 3 4];
for k = 1:numel(solver_names)
    ind = strcmpi(solver_str,solver_names{k});
    tmp = res(ind,:);
    nr = reshape([tmp.num_real],1,[]);
    real_histcount_list(k,:) = histcounts(nr(:),edges);
    nf = reshape([tmp.num_feasible],1,[]);
    feas_histcount_list(remapit(k),:) = histcounts(nf(:),edges2);
    longreal = cat(1,longreal,[repmat(remapit(k),numel(nr(:)),1) nr(:)]);
end

longreal = [longreal(:,2) longreal(:,1)];

%b1 = bar(edges(1:end-1)', ...
%         real_histcount_list');
%for k = 1:numel(b1)
%    b1(k).FaceColor = colormap(solver_names{k});
%end
figure;
ctrs = { [1:5:41] , [1:7] };
hist3(longreal,ctrs)
S = findobj('type','surf');
for k1 = 1:5:size(S.CData,2)
    for k2 = 1:size(S.CData,1)
        color = colormap(solver_names{ remapit((k1-1)/5 +1) } );
        S.CData(:,k1:k1+4,:) = repmat(permute(color,[3 1 2]),size(S.CData,1),5,1);
    end
end

ZD = get(S,'ZData');
ZD(~ZD) = .1;
set(S,'ZData',ZD);
set(gca,'zscale', 'log'); 
xlabel('Number of Real Solutions')
zlabel('Frequency');
yticks([]);
%yticklabels(solver_names(remapit));
xticks(0:5:45);
%yticks([0 10 10^2 10^3 10^4 10^5]);
view([35 35])
pbaspect([2 1 0.8]);
grid off;
xlabel('');
xlh = get(gca,'xlabel');
%ylp = get(ylh, 'Position');
%ext=get(y_h,'Extent');
%
%set(xlh, 'Rotation',-22)

matlab2tikz([target_path 'real_solutions.tikz'], ...
            'width', '\fwidth','extraAxisOptions',axis_options);
 
figure;
b2 = bar(edges2(1:end-1)', ...
         feas_histcount_list(:,1:3)');
for k = 1:numel(b2)
    b2(remapit(k)).FaceColor = colormap(solver_names{k});
end
set(gca,'YScale','log');
xlabel('Number of Feasible Solutions')
ylabel('Frequency (150000 trials)');
xticks(1:3);

axis square;
pbaspect([16 9 1]);

matlab2tikz([target_path 'feasible_solutions.tikz'], ...
            'width', '\fwidth','extraAxisOptions',axis_options);