function [G_rt,Rt] = segment_motions(u,M,Hinf,varargin)
cfg.sigma = 1;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

vq_distortion = 21.026*cfg.sigma^2;

v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);
N = height(M);
[aa,bb] = meshgrid(1:N,1:N);

Rt = [M.theta(bb,:)'; M.tij(bb,:)'];

Hinv = inv(Hinf);
x = ...
    LAF.renormI(blkdiag(Hinv,Hinv,Hinv)*...
                LAF.apply_rigid_xforms(v(:,M.i(aa(:))),Rt));    
y = u(:,M.j(aa(:)));
d2 = sum((y-x).^2);
d2 = reshape(d2',N,N);

d2 = d2+d2';
K =  d2 < vq_distortion;

nMatches = max(sum(K),sum(K,2)');
is_valid = find(nMatches > 1);
K = K(is_valid,is_valid);
K = tril(K,0);

disp(['Entering vq']);
w = lp_vq(K);
disp(['Leaving vq']);

wold = w;
for k = 1:numel(w)
    w1 = w;
    w1(k) = 0;
    b = K*w1; 
    if all(b > 0.1)
        w = w1;
    end
end

motion_quantizers = find(w>0);
dd = d2(:,motion_quantizers);
[ddd,Gmq] = min(dd,[],2);
Gmq(ddd > vq_distortion) = nan;
G_rt = findgroups(Gmq);

theta_uw = msplitapply(@(theta)  unwrap(theta), M.theta, G_rt);
M{~isnan(G_rt),'theta'} = theta_uw(~isnan(G_rt));
Rt = cmp_splitapply(@(u) mean(u,1), [M.theta M.tij] ,G_rt)';
G_rt = reshape(G_rt,[],1);
