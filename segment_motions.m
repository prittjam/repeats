function [G_rt,rt] = segment_motions(u,u_corr,model,varargin)
cfg.sigma = 1;
[cfg,leftover] = cmp_argparse(cfg,varargin{:});
vq_distortion = 21.026*cfg.sigma^2;

Hinf = model.Hinf;
v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*LAF.ru_div(u,model.cc,model.q));

M = height(u_corr);

num_codes = 1e3;
if M > num_codes
    ind = randsample(M,num_codes);
else
    ind = 1:M;
end

N = numel(ind);

Hinv = inv(Hinf);
rt = [u_corr.theta(ind,:)'; ...
      u_corr.tij(ind,:)'; ...
      u_corr.a11(ind,:)'];

[aa,bb] = ndgrid(1:M,1:N);
ut_j = LAF.rd_div(LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                              LAF.apply_rigid_xforms(v(:,u_corr.i(aa,:)),rt(:,bb))),model.cc,model.q);
invrt = Rt.invert(rt);
ut_i = LAF.rd_div(LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                              LAF.apply_rigid_xforms(v(:,u_corr.j(aa,:)), ...
                                                  invrt(:,bb))),model.cc,model.q);
d2 = sum([ut_j-u(:,u_corr.j(aa,:)); ...
          ut_i-u(:,u_corr.i(aa,:))].^2);
d2 = reshape(d2,M,N);

K = double(d2 < vq_distortion);

is_valid_ii = find(any(K,2));
is_valid_jj = find(any(K,1));
K = K(is_valid_ii,is_valid_jj);

w0 = lp_vq(K);
w = rm_duplicate_codes(K,w0);

code_ind = is_valid_jj(find(w>0));
d2c = d2(:,code_ind);
[min_d2c,G] = min(d2c,[],2);

valid_pairs = min_d2c < vq_distortion;
G_rt = nan(size(G));
G_rt(valid_pairs) = findgroups(G(valid_pairs));

theta_uw = msplitapply(@(theta)  unwrap(theta), u_corr.theta, G_rt);
u_corr{~isnan(G_rt),'theta'} = theta_uw(~isnan(G_rt));

rt = ...
    cmp_splitapply(@(u) ...
                   [ atan2(mean(sin(u(:,1))),mean(cos(u(:,1)))) mean(u(:,2:3),1) median(u(:,4)) ], ...
                   [u_corr.theta u_corr.tij u_corr.a11], G_rt)';

G_rt = reshape(G_rt,[],1);
