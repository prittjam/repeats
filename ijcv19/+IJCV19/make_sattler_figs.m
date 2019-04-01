function [] = make_sattler_figs()
results_dir = 'results/WRAP.laf222_to_ql';
dt_list = get_dt_list(results_dir);
for k = 1:numel(dt_list)
    pth_list{k} = fullfile(results_dir,dt_list{k});
end
summary = load_results(pth_list);
u = linspace(1,500,1000);
v = zeros(size(summary,1),1000);
figure;
for k = 1:numel(summary)
    ex = summary(k);
    local_stats = [ex.stats_list(1).local_list(:)];
    trial_count = [local_stats(:).trial_count];
    local_res = [local_stats(:).res];
    local_loss = [local_res(:).loss];
    x = trial_count;
    y = local_loss;
    keyboard;
    v(k,:) = interp1(x,y,u,'linear');    
    minvk = min(v(k,:));
    keyboard;
    v(k,isnan(v(k,:))) = minvk;
    hold on;
    plot(u,v(k,:),'r-');
    plot(x,y,'b*');
    hold off;
end









function summary = load_results(pth_list)
num_results = 1;
mat_pth_list = [];
for k = 1:numel(pth_list)
    search = fullfile(pth_list{k},['*.mat']);
    results_list0 = dir(search);
    mat_pth_list = cat(2,results_list0,mat_pth_list);
end

for k = 1:numel(mat_pth_list)
    fpath = fullfile(mat_pth_list(k).folder,mat_pth_list(k).name);
    summary(k) = load(fpath); 
end


function subDirsNames = get_dt_list(parentDir)
% Get a list of all files and folders in this folder.
files = dir(parentDir);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subDirs = files(dirFlags);
subDirsNames = cell(1, numel(subDirs) - 2);
for i=3:numel(subDirs)
    subDirsNames{i-2} = subDirs(i).name;
end

%load_results(dt_list)


%res1 = load(['results/WRAP.laf222_to_ql/20190330_202246/' ...
%             'cropped_dartboard.mat']);
%res2 = load('results/WRAP.laf22_to_ql/20190331_152021/cropped_dartboard.mat');
%
%
%
%
%
%res = res1;
%
%local_stats = [res.stats_list(1).local_list(:)];
%local_res = [local_stats(:).res]
%local_loss = [local_res(:).loss];
%local_cs = [local_res(:).cs];
%
%global_stats = [res.stats_list(1).global_list(:)];
%global_res = [global_stats(:).res];
%global_loss = [global_res(:).loss];
%global_cs = [global_res(:).cs];
%
%figure;
%hold on;
%plot(local_loss,'Color','r')
%plot(global_loss,'Color','r', 'LineStyle','--');
%hold off;
%
%res = res2;
%
%local_stats = [res.stats_list(1).local_list(:)];
%local_res = [local_stats(:).res]
%local_loss = [local_res(:).loss];
%
%global_stats = [res.stats_list(1).global_list(:)];
%global_res = [global_stats(:).res];
%global_loss = [global_res(:).loss];
%
%hold on;
%plot(local_loss,'Color','g')
%plot(global_loss,'Color','g', 'LineStyle','--');
%hold off;
