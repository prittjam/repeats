function [] = make_cdf_warp_fig(src_path,target_path,colormap,color_list)
repeats_init();
axis_options = {'enlargelimits=false'};  
sensitivity = load(src_path);
data = innerjoin(sensitivity.res,sensitivity.gt, ...
                 'LeftKeys','ex_num','RightKeys','ex_num');
q_gt = unique(data.q_gt)*sum(2*sum(sensitivity.cam.cc))^2;

assert(numel(q_gt)>0,'Cannot have different distortion parameters');
qres = array2table([data.q*sum(2*sum(sensitivity.cam.cc))^2 ...
                    data.ransac_q*sum(2*sum(sensitivity.cam.cc))^2 ...
                    1-data.q./data.q_gt ...
                    1-data.ransac_q./data.q_gt ...
                    data.rewarp ...
                    data.ransac_rewarp ], ...
                   'VariableNames', ...
                   {'q','ransac_q', 'q_relerr', ...
                    'ransac_q_relerr', 'rewarp','ransac_rewarp'}); 

res = [data(:,{'ex_num','scene_num','solver','sigma'}) qres];
solver_list = unique(res.solver,'stable');

Lia = res.sigma == 1;
Lid = ismember(res.solver,setdiff(solver_list,{'$\mH22\lambda$'}));

solver_ind = find(Lid(1:numel(solver_list)));
is_valid = Lia & Lid;
ind = find(is_valid);

keyboard;

figure;
for k = 1:numel(solver_ind)
    solver_name = cellstr(solver_list(solver_ind(k)));
    linecolor = colormap(solver_name{:});
    %    set(h,'color',colormap(solver_name{:}));
    ind2 = find(ismember(res.solver(ind),solver_list(solver_ind(k))));
    x = res.rewarp(ind(ind2));
    [f,xi] = ksdensity(x,0:0.1:max(x), ...
                       'BoundaryCorrection','reflection');
    y = cumsum(f);
    y = y/max(y);

    hold on;
    plot(xi,y,'Color',linecolor,'LineWidth',1.5);
    hold off;
    %%    h = cdfplot(res.rewarp(ind(ind2)));
end
ylim([0,0.8]);
xlim([0 15]);
xticks([0:5:15]);
xlabel('$\Delta^{\mathrm{warp}}_{\mathrm{RMS}}$ [pixels] at $\sigma=1$ pixel', ...
       'Interpreter','Latex','Color','k'); 
ylabel('$p(x < \Delta^{\mathrm{warp}}_{\mathrm{RMS}})$', ...
       'Interpreter','Latex');
grid off;
title('');
lh = legend(cellstr(solver_list(solver_ind)), ...
            'Location','northwest', ...
            'Interpreter','Latex', ...
            'FontSize', 10);

legend boxoff;

drawnow;

cleanfigure('targetResolution',100);
matlab2tikz([target_path 'ecdf_warp_1px_ct.tikz'], ...
            'width', '\fwidth', 'extraAxisOptions',axis_options);



%title('Empirical CDF of RMS warp error');

%legend('off');