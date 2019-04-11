function summary_list = make_sattler_figs()
summary_list_path = 'results/sattler*.mat';
listing = dir(summary_list_path);
summary_list_path = [listing(end).folder '/' listing(end).name];
load(summary_list_path);

[~,~,colormap] = IJCV19.make_solver_list();

solver_categories = unique(summary_list.solver_name);
camera_categories = unique(summary_list.camera_name);
solver_names = cellstr(solver_categories);

img_stats = cell2table(cell(0,5),'VariableNames', ...
                       {'img_path', 'local_min_loss', 'local_max_loss', 'global_min_loss', 'global_max_loss'});

stats_list =  cell2table(cell(0,4),'VariableNames', ...
                         {'solver_name', 'camera_name', 'local_loss', 'trial_count'});

uimg_path_list = unique(summary_list.img_path);

%summary_list = IJCV19.fix_summary_list(summary_list);

color_list = {'r','g','b','c','y','m'};
line_style = {'-','--'};

for k = 1:numel(uimg_path_list)
    rows = find(cellfun(@(x) strcmpi(x,uimg_path_list{k}) , ...
                        summary_list.img_path));
    ex = summary_list(rows,:);
    num_rows = size(ex,1);

    max_nll = -inf;
    min_nll= inf;

    nll = zeros(num_rows,501);
    u = 0:500; 
    
    for k3 = 1:num_rows
        local_stats = [ex(k3,:).stats_list(1).local_list(:)];
        local_res = [local_stats(:).res];
        trial_count = [local_stats(:).trial_count];
        local_loss = [local_res(:).loss];
        x = [0 trial_count];
        y = -[ex(k3,:).stats_list(1).max_loss local_loss];

        if numel(x) > 1
            nll(k3,:) = interp1(x,y,u,'linear');    
        else
            nll(k3,:) = nan(1,size(nll,2));
            nll(k3,1) = y(1);
        end
        nll(k3,isnan(nll(k3,:))) = -min(local_loss);
    end

    min_nll = min(nll(:));
    max_nll = max(nll(:));
  
    for k3 = 1:num_rows
        nll(k3,:) = (nll(k3,:)-min_nll)./(max_nll-min_nll);
        row = { ex(k3,:).solver_name, ex(k3,:).camera_name, nll(k3,:), u };
        tmp_stats = stats_list;
        stats_list = [tmp_stats; row]; 
    end
end

figure;
for k1 = 1:numel(solver_categories)
    for k2 = 1:numel(camera_categories)
        rows = find(strcmpi(stats_list.solver_name,solver_categories{k1}) ...
                    & strcmpi(stats_list.camera_name,camera_categories{k2}));
        ex = stats_list(rows,:);
        color = colormap(solver_categories{k1});
        loss = [ex.local_loss];
        if size(loss,1) > 1
            mean_loss = mean(loss);
        else
            mean_loss = loss;
        end
        hold on;
        plot(mean_loss,'Color', color_list{k2}, 'LineStyle',line_style{k1});
        hold off;
    end
%    set(leg1, 'FontSize', 10);
%    set(leg1,'Interpreter','Latex');
end

keyboard;
legend(camera_categories{:},'Location','northeast');
%
%        
%keyboard;
%for k2 = 1:numel(camera_categories)
%    for k1 = 1:numel(solver_categories)
%        v = c[cellstr(solver_categories(k1))':' ...
%              cellstr(camera_categores)];
%        meanv = mean(v);
%        figure;
%        hold on;       
%        for k3 = 1:num_rows
%            plot(u,v(k3,:),'r-','LineWidth',3);
%        %        plot(x,y,'b*');
%        end
%        hold ff;
%        plot(u,meanv,'g-','LineWidth',3);
%        hold off;
%    end
%end