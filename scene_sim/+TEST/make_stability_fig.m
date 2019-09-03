function [] = make_stability_fig(src_path,target_path,colormap,linestylemap)
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

Lia = res.sigma == 0;
solver_ind = find(Lia(1:numel(solver_list)));
ind = find(Lia);

figure;
for k = 1:numel(solver_ind)
    solver_name = cellstr(solver_list(solver_ind(k)));
    linecolor = colormap(solver_name{:});
    linestyle = linestylemap(solver_name{:});
    ind2 = find(ismember(res.solver(ind),solver_list(solver_ind(k))));
    x = res.rewarp(ind(ind2));
    [f,xi] = ksdensity(log10(abs(x)),'Support',[-15 5]);
    hold on;
    plot(xi,f,'Color',linecolor, ...
         'LineWidth',1, ...
         'Linestyle',linestyle);
    hold off;
end

%ylim([0,0.8]);
%xlim([0 15]);
%xticks([0:5:15]);
xlim ([-15 5])

set(gca,'fontsize',10);
set(gcf,'color','w');
xlabel(['$\log_{10} \Delta^{\mathrm{warp}}_{\mathrm{RMS}}$ (' ...
        'see Sec.~\ref{sec:warp_error})'],'Interpreter','Latex');
ylabel('$p(x=\log_{10} \Delta^{\mathrm{warp}}_{\mathrm{RMS}})$', ...
       'Interpreter','Latex');
grid off;
title('');
legend(categories(solver_list),'Interpreter','Latex');
pbaspect([16 9 1]);

drawnow;
cleanfigure;
matlab2tikz([target_path 'rms_stability.tikz'], ...
            'width', '\fwidth', ...
            'extraAxisOptions','enlargelimits=false');