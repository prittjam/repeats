function [cs,theta,t] = calc_pwise_registration_err(u,H,motion_model,varargin)
cfg.dist_cutoff = 3.0;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

v = LAF.renormI(blkdiag(H,H,H)*u);
invH = inv(H);

[Rt,ii,jj] = HG.laf2xNxN_to_RtxNxN(v,'motion_model',motion_model);

M = numel(Rt);
cs = nan(1,M);
err = zeros(1,M);

keyboard;

ut = LAF.renormI(blkdiag(invH,invH,invH)* ...
                 LAF.apply_rigid_xforms(v(:,ii),[Rt(:).theta],[Rt(:).t]));
du = reshape(ut-u(:,jj),3,[]);
d = max(reshape(sqrt(sum(du.^2)),3,[]));

Z = linkage(d,'single');
T = cluster(Z,'cutoff', cfg.dist_cutoff,'criterion','distance');

freq = hist(T,1:max(T));
[max_freq,maxc] = max(freq);
if max_freq > 3
    cs(find(T==maxc)) = 1;
end
