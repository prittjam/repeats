function Gm = segment_motions(u,v,model,xform_list,varargin)
cfg.sigma = 1;
cfg.num_codes = 1e3;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

vq_distortion = 21.026*cfg.sigma^2;

Hinf = model.Hinf;

M = numel(xform_list);
if M > cfg.num_codes
    ind = randsample(M,cfg.num_codes);
else
    ind = 1:M;
end

N = numel(ind);
Hinv = inv(Hinf);

rt = [xform_list(ind).Rt];
[aa,bb] = ndgrid(1:M,1:N);

ut_j = LAF.rd_div(LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                              LAF.apply_rigid_xforms(v(:,[xform_list(aa).i]),rt(:,bb))),model.cc,model.q);
invrt = Rt.invert(rt);
ut_i = LAF.rd_div(LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                              LAF.apply_rigid_xforms(v(:,[xform_list(aa).j]), ...
                                                  invrt(:,bb))),model.cc,model.q);
d2 = sum([ut_j-u(:,[xform_list(aa).j]); ...
          ut_i-u(:,[xform_list(aa).i])].^2);
d2 = reshape(d2,M,N);
K = double(d2 < vq_distortion);

is_valid_ii = find(any(K,2));

K = K(is_valid_ii,any(K,1));
w0 = lp_vq(K);
w = rm_duplicate_codes(K,w0);

code_ind = find(w>0);
d2c = d2(:,code_ind);
[min_d2c,Gm] = min(d2c,[],2);

Gm(min_d2c > vq_distortion) = nan;
Gm = findgroups(Gm);

%theta_uw = msplitapply(@(theta)  unwrap(theta), u_corr.theta, G_rt);
%u_corr{~isnan(G_rt),'theta'} = theta_uw(~isnan(G_rt));
%
%rt = ...
%    cmp_splitapply(@(u) ...
%                   [ atan2(mean(sin(u(:,1))),mean(cos(u(:,1)))) mean(u(:,2:3),1) median(u(:,4)) ], ...
%                   [u_corr.theta u_corr.tij u_corr.a11], G_rt)';
%
%G_rt = reshape(G_rt,[],1);
