function  dr = make_dr(varargin)
addpath('../');

cfg.num_planes = 1;

[cfg,~] = cmp_argparse(cfg,varargin{:});
 
img_key = reshape(dec2hex(uint32(ceil(double(intmax)*rand(1,4)))),1,32);
%img_cache = image_cache(cvdb_open(),img_key);

for k = 1:cfg.num_planes
   sp{k} = SIM.random_scene_plane(); 
   pattern{k} = SIM.random_coplanar_pattern(sp{k});
   pattern{k}.make(sp{k},varargin{:});
end

n = size(pattern{1}.X,2);
w = max(sp{1}.X(2,:))-min(sp{1}.X(2,:));
h = max(sp{1}.X(3,:))-min(sp{1}.X(3,:));
g = [0 0 -1]'; % gravity direction
[P0 nx ny q_gt cc ccd_sigma] = ...
    SIM.make_cam(PT.to_euclidean(sp{1}.M*[g;1]), ...
                 w,h,w*50/36,varargin{:});
P = P0*sp{1}.M;

num_lafs = zeros(1,cfg.num_planes);

for k = 1:cfg.num_planes
    num_lafs(k) = num_lafs(k)+numel(unique(pattern{k}.ctg.clust_ctgs))-1;
end
nlafs = sum(num_lafs);
elabel = nlafs+1;

labels = [];
for k = 1:cfg.num_planes
    elabel0 = find(pattern{k}.ctg.outlier_ctgs);
    ioutlier = find(pattern{k}.labels == elabel0);
    labels = pattern{k}.labels;
    pattern{k}.labels(ioutlier) = elabel;
end

for k = 2:cfg.num_planes
   pattern{k}.labels = pattern{k}.labels+num_lafs(k-1);
end


ctg = struct('plane_ctgs',zeros(1,nlafs+1), ...
             'clust_ctgs',zeros(1,nlafs+1), ...
             'outlier_ctgs',zeros(1,nlafs+1));
ctg.plane_ctgs(1:nlafs) = 1;
ctg.clust_ctgs(1:nlafs) = 1:nlafs;
ctg.outlier_ctgs(end) = 1;

udn_laf = [];
for k = 1:cfg.num_planes
    u = renormI(P*pattern{k}.X);
    ud = CAM.distort_div(u,cc,q_gt);
    ud_laf = reshape(ud,9,[]);
    %    udn = ud+[normrnd(0,ccd_sigma,[2 n]);zeros(1,n)];
    udn = ud;
    udn_laf = cat(2,udn_laf,reshape(udn,9,[]));
end

[desc,xdesc,drid] = SIM.make_sifts(labels,ctg,varargin{:});
dr = struct('u',mat2cell(udn_laf,9,ones(1,size(udn_laf,2))), ...
            'desc',mat2cell(desc,128,ones(1,size(udn_laf,2))), ...
            'xdesc',mat2cell(xdesc,128,ones(1,size(udn_laf,2))), ...
            'drid', mat2cell(drid,1,ones(1,numel(drid))));