function [] = make_stability_figs()
cj_init('..');

stability = load('stability.mat');
data = innerjoin(stability.res,stability.gt, ...
                 'LeftKeys','ex_num','RightKeys','ex_num');

q_gt = unique(data.q_gt)*sum(2*sum(stability.cam.cc))^2;

assert(numel(q_gt)>0,'Cannot have different distortion parameters');
qres = array2table(data.rms,'VariableNames', {'rms'}); 
res = [data(:,{'solver','variant','sigma'}) qres];

solver_list = unique(res.solver);

color_list = [ 0.85 0.85 0; ...
               1 0 0; ...
               0 1 0; ...
               0 0 0; ...
               0 0 1; ...
               0 1 1; ...
               1 0 1; ...
               1 0.6 0];

res_list{1} = res(find(strcmpi(res.variant,'det')),:);
res_list{2} = res(find(strcmpi(res.variant,'gb')),:);

figure;
for k = 1:2 
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
matlab2tikz('/home/prittjam/Documents/eccv18/fig/rms_stability.tikz', ...
            'width', '\fwidth', ...
            'extraAxisOptions','enlargelimits=false');

%ind = find(Lib);
%nanres = res(ind,:);
%G = findgroups(nanres.solver);
%input.data = ...
%    transpose(cmp_splitapply(@(x,y) numel(unique((isnan(x)))),...
%                             nanres.q,nanres.scene_num,G));
%
%solver_names = arrayfun(@(x) [char(x)], solver_list, ...
%                        'UniformOutput',false);
%% Set column labels (use empty string for no label):
%input.tableColLabels = transpose(solver_names); 
%% Set row labels (use empty string for no label):
%%input.tableRowLabels = {'freq.'};
%
%% Switch transposing/pivoting your table:
%input.transposeTable = 0;
%
%% Determine whether input.dataFormat is applied column or row based:
%input.dataFormatMode = 'column'; % use 'column' or 'row'. if not set 'colum' is used
%
%% Formatting-string to set the precision of the table values:
%% For using different formats in different rows use a cell array like
%% {myFormatString1,numberOfValues1,myFormatString2,numberOfValues2, ... }
%% where myFormatString_ are formatting-strings and numberOfValues_ are the
%% number of table columns or rows that the preceding formatting-string applies.
%% Please make sure the sum of numberOfValues_ matches the number of columns or
%% rows in input.tableData!
%%
%input.dataFormat = {'%.0f',numel(input.data) }; % three digits precision for first two columns, one digit for the last
%
%% Define how NaN values in input.tableData should be printed in the LaTex table:
%input.dataNanString = '-';
%
%% Column alignment in Latex table ('l'=left-justified, 'c'=centered,'r'=right-justified):
%input.tableColumnAlignment = 'c';
%
%% Switch table borders on/off (borders are enabled by default):
%input.tableBorders = 1;
%
%% Uses booktabs basic formating rules ('1' = using booktabs, '0' = not using booktabs). 
%% Note that this option requires the booktabs package being available in your LaTex. 
%% Also, setting the booktabs option to '1' overwrites input.tableBorders if it exists.
%% input.booktabs = 0;
%
%% LaTex table caption:
%input.tableCaption = 'Number of no solutions for $1000$ scenes';
%
%% LaTex table label:
%input.tableLabel = 'tab:no_solution_freq';
%
%% Switch to generate a complete LaTex document or just a table:
%input.makeCompleteLatexDocument = 0;
%
%% call latexTable:
%
%latex = latexTable(input);
%
%[nrows,ncols] = size(latex);
%fileId = fopen('/home/prittjam/Documents/eccv18/no_solutions.tex','w');
%for row = 1:nrows
%    fprintf(fileId,'%s\n',latex{row,:});
%end
%fclose(fileId);
%
function h = smooth_hist(x,log_range)
totalmin = 1e-20;
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
