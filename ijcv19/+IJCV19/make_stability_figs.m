function [] = make_stability_figs()
[solver_names,solver_list,colormap,linestylemap] = IJCV19.make_stability_solver_list();

target_path = '/home/jbpritts/Documents/ijcv19/fig2/';
wildcard = 'results/stability*.mat';
stability_listing = dir(wildcard);
stability_file_path = [stability_listing(end).folder '/' stability_listing(end).name];
load(stability_file_path);
keyboard;

figure;
for k = 1:numel(solver_names)
    [G,solver_list] = findgroups(res_list{k}.solver);
    logxmin = -15;
    logxmax = 5;
    log_range = [logxmin:0.3:logxmax];
    hold on;
    hlist = cmp_splitapply(@(x) smooth_hist(x,log_range), ...
                           res_list{k}.rms,G);
    hold off;
    hlist = [hlist(:)];
    color_ind = [2:5];
    for k2 = 1:numel(hlist)
        set(hlist(k2), ...
            'Color',color_list(color_ind(k2),:));
        if k == 2
            set(hlist(k2), 'LineStyle','--');
        end
    end
end
    
set(gca,'fontsize',10);
set(gcf,'color','w');
xlabel(['$\log_{10} \Delta^{\mathrm{xfer}}_{\mathrm{RMS}}$ (' ...
        'see Sec.~\ref{sec:transfer_error})'],'Interpreter','Latex');
ylabel('Frequency');
legend(categories(solver_list),'Interpreter','Latex');
pbaspect([16 9 1]);

drawnow;
cleanfigure;
matlab2tikz('/home/jbpritts/Documents/pami19/fig2/rms_stability.tikz', ...
            'width', '\fwidth', ...
            'extraAxisOptions','enlargelimits=false');
function h = smooth_hist(x,log_range)
totalmin = 1e-20;
logxmin = -15;
logxmax = 5;
used = find(x == 0);
x(used) = totalmin;
h = hist(log10(abs(x)), log_range);

ks = 3;
g=normpdf([-ks:ks],0,2);
g = g/sum(g);
v = conv(h, g);

h = plot(log_range, ...
         v(ks:end-(ks+1)), ...
         'LineWidth',2);
