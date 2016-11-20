function [cs,theta,t] = calc_pwise_registration_err(u,H,est_xform)
M = size(u,2);

v = LAF.renormI(blkdiag(H,H,H)*u);
invH = inv(H);

[ii,jj] = find(tril(ones(M,M),-1));
N = numel(ii);

v2 = [v(:,ii); ...
      v(:,jj)];

Rt = feval(est_xform,v2);

cs = nan(1,M);
err = zeros(1,M);
ut = LAF.renormI(blkdiag(invH,invH,invH)* ...
                 LAF.apply_rigid_xforms(v(:,ii),Rt(1,:),Rt(2:3,:)));
du = reshape(ut-u(:,jj),3,[]);
d = max(reshape(sqrt(sum(du.^2)),3,[]));

Z = linkage(d,'single');
T = cluster(Z,'cutoff', 3.0, ...
            'criterion','distance');

freq = hist(T,1:max(T));
[max_freq,maxc] = max(freq);
if max_freq > 3
    cs(find(T==maxc)) = 1;
end