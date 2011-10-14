function u = tc_match_nview(results_dir,idx)
img_dir = '../task_1-1/';
results_dir = 'results/';

load([results_dir 'tc.mat']); 
listing = dir(fullfile(img_dir,'*.jpg'));

K = size(TC,2);
M = numel(idx);

ib = 1:size(TC{idx(1),idx(2)},2);
for m = 1:M-2
    tc1 = TC{idx(m),idx(m+1)};
    tc2 = TC{idx(m+1),idx(m+2)};
    [ids,ia,ib] = intersect(tc1(2,ib),tc2(1,:));
    numel(ids)
    numel(ib)
end

tc1 = tc2;
tc2 = TC{idx(1),idx(M)};
[ids,ia,ib] = intersect(tc1(2,ib),tc2(2,:));
ids = tc2(1,ib);
numel(ids)
numel(ib)


u = [];
for m = 1:M-1
    img_file_name1 = listing(idx(m)).name;
    [pathstr,name] = fileparts(img_file_name1);
    dr_file_name = [results_dir name '_dr.mat'];    
    load(dr_file_name);
    tc = TC{idx(m),idx(m+1)};
    [ids,ia] = intersect(tc(1,:),ids);
    u = cat(1,u, ...
            [ pts(ids).x; ...
              pts(ids).y; ...
              ones(1,numel(ids)) ]);
    
    ids = tc(2,ia);
end

img_file_name1 = listing(idx(end)).name;
[pathstr,name] = fileparts(img_file_name1);
dr_file_name = [results_dir name '_dr.mat'];    
load(dr_file_name);

u = cat(1,u, ...
        [ pts(ids).x; ...
          pts(ids).y; ...
          ones(1,numel(ids)) ]);