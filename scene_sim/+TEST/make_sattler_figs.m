function summary_list = make_sattler_figs()
summary_list_path = 'results/sattler*.mat';
listing = dir(summary_list_path);
summary_list_path = [listing(end).folder '/' listing(end).name];
load(summary_list_path);

[~,~,colormap] = PAMI19.make_solver_list();

solver_categories = unique(summary_list.solver_name);
camera_categories = unique(summary_list.camera_name);

img_stats = cell2table(cell(0,5),'VariableNames', ...
                       {'img_path', 'local_min_loss', 'local_max_loss', ...
                    'global_min_loss', 'global_max_loss'});

stats_list =  cell2table(cell(0,6),'VariableNames', ...
                         {'solver_name', 'camera_name', 'local_nll', ...
                    'local_nxfer', 'local_nwarp', 'trial_count'});

uimg_path_list = unique(summary_list.img_path);
color_list = {'r','g','b','c','y','m'};
line_style = {'-','--','-.'};

max_trials = 151;

for k = 1:numel(uimg_path_list)
    rows = find(cellfun(@(x) strcmpi(x,uimg_path_list{k}), ...
                        summary_list.img_path));
    ex = summary_list(rows,:);
    num_rows = size(ex,1);
    
    max_nll = -inf;
    min_nll= inf;

    nll = zeros(num_rows,max_trials);
    xfer = zeros(num_rows,max_trials);
    warp = zeros(num_rows,max_trials);
    u = 0:max_trials-1; 

    for k3 = 1:num_rows
        local_stats = [ex(k3,:).stats_list(1).local_list(:)]; 
        global_stats = [ex(k3,:).stats_list(1).global_list(:)]; 

        local_res = [local_stats(:).res];
        trial_count = [local_stats(:).trial_count];
        gtrial_count = [global_stats(:).trial_count]
        local_loss = [local_res(:).loss];
        % tst = local_loss(1:end-1)-local_loss(2:end);
        %        assert(all(tst > 0), 'Likelihood decreased');
        x = [0 trial_count];
        gx = [0 gtrial_count];

        xfer = [ex(k3,:).opt_xfer_list{:}]; 
        xfer = [xfer(1) xfer];

        warp = [ex(k3,:).opt_warp_list{:}];
        warp = [warp(1) warp];
        
        y = -[ex(k3,:).stats_list(1).max_loss local_loss];
        if numel(x) > 1
            nll(k3,:) = interp1(x,y,u,'linear');    
            nxfer(k3,:) = interp1(gx,xfer,u,'linear');
            nwarp(k3,:) = interp1(gx,warp,u,'linear');
        else
            nll(k3,:) = nan(1,size(nll,2));
            nll(k3,1) = y(1);
            nxfer(k3,:) = nan(1,size(nll,2));
            nwarp(k3,:) = nan(1,size(nll,2));
        end
        nll(k3,isnan(nll(k3,:))) = -min(local_loss);

        doit = find(isnan(nwarp(k3,:)));
        if ~isempty(doit)
            nwarp(k3,doit) = nwarp(k3,doit(1)-1);
        end
        
        doit = find(isnan(nxfer(k3,:)));
        if ~isempty(doit)        
            nxfer(k3,doit) = nxfer(k3,doit(1)-1);
        end
    end
    
    min_nll = min(nll(:));
    max_nll = max(nll(:));
  
    for k3 = 1:num_rows
        nll(k3,:) = (nll(k3,:)-min_nll)./(max_nll-min_nll);
        row = { ex(k3,:).solver_name, ...
                ex(k3,:).camera_name, ...
                nll(k3,:), ...
                nxfer(k3,:), ...
                nwarp(k3,:), ...
                u };
        tmp_stats = stats_list;
        stats_list = [tmp_stats; ...
                      row]; 
    end
end


for k1 = 1:numel(solver_categories)
    for k2 = 1:numel(camera_categories)
        rows = find(strcmpi(stats_list.solver_name,solver_categories{k1})  & ...
                    strcmpi(stats_list.camera_name, ...
                            camera_categories{k2}));
        ex = stats_list(rows,:);
        nll = ex.local_nll;
        nwarp = ex.local_nwarp;
        nxfer = ex.local_nxfer;
        if size(nll,1) > 1
            mean_nll = mean(nll);
            mean_warp = mean(nwarp);
            mean_xfer = mean(nxfer);                    
        else
            mean_nll = nll;
            mean_warp = nwarp;
            mean_xfer = nxfer;                    
        end

        figure(1);
        hold on;
        figure(1);
        plot(mean_nll,'Color', ...
             colormap(solver_categories{k1}), ...
             'LineStyle','-');
        legend('off');
        hold off;
        
        figure(2);
        hold on; 
        plot(mean_warp,'Color', ...
             colormap(solver_categories{k1}), ...
             'LineStyle','-');
        legend('off');
        hold off;
        
        figure(3);
        hold on; 
        plot(mean_xfer,'Color', ...
             colormap(solver_categories{k1}), ...
             'LineStyle','-');                
        legend('off');
        hold off;
    end
end

%    set(leg1, 'FontSize', 10);
%    set(leg1,'Interpreter','Latex');

target_path = '/home/jbpritts/Documents/pami19/fig2/';

figure(1);
%legend(solver_categories{:},'Location','southeast');
xlabel('RANSAC iterations');
ylabel('Mean Normalized Negative Log Likelihood');
axis_options = {'enlargelimits=false'};  
cleanfigure;
matlab2tikz([target_path 'nll_comparisons.tikz'], ...
            'width', '\fwidth', ...
            'extraAxisOptions',axis_options);

figure(2);
%legend(solver_categories{:},'Location','southeast');
xlabel('RANSAC iterations');
ylabel('Mean RMS Warp Error');
ylim([0 50]);
axis_options = {'enlargelimits=false'};  
cleanfigure;
matlab2tikz([target_path 'mean_warp_comparisons.tikz'], ...
            'width', '\fwidth', ...
            'extraAxisOptions',axis_options);

figure(3);
%legend(solver_categories{:},'Location','southeast');
xlabel('RANSAC iterations');
ylabel('Mean RMS Transfer Error');
ylim([0 50]);
axis_options = {'enlargelimits=false'};  
cleanfigure;
matlab2tikz([target_path 'mean_xfer_comparisons.tikz'], ...
            'width', '\fwidth', ...
            'extraAxisOptions',axis_options);