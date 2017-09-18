function Gm = new_segment_motions(x,model,corresp,rt0,varargin)
cfg.sigma = 1;
cfg.num_codes = 1e3;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

vq_distortion = 21.026*cfg.sigma^2;

Hinf = model.Hinf;
Hinv = inv(Hinf);

xp = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*LAF.ru_div(x,model.cc, ...
                                                  model.q));
xp2 = LAF.apply_rigid_xforms(xp(:,corresp(1,:)),rt0);
dist = xp2-xp(:,corresp(2,:));

M = size(corresp,2);
if M > cfg.num_codes
    ind = randsample(M,cfg.num_codes);
else
    ind = 1:M;
end

N = numel(ind);

is_inverted = false(1,N);
[rt,is_inverted] = unique_ro(rt0);
[corresp(2,is_inverted),corresp(1,is_inverted)] = ...
    deal(corresp(1,is_inverted),corresp(2,is_inverted));
[aa,bb] = ndgrid(1:M,1:N);

c1 = corresp(1,aa);
c2 = corresp(2,aa);

ut_j = LAF.rd_div(LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                              LAF.apply_rigid_xforms(xp(:,c1),rt(:,bb))),...
                  model.cc,model.q);
invrt = Rt.invert(rt);
ut_i = LAF.rd_div(LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                              LAF.apply_rigid_xforms(xp(:,c2), ...
                                                  invrt(:,bb))),...
                  model.cc,model.q);
d2 = sum([ut_j-x(:,c2);  ...
          ut_i-x(:,c1)].^2);
d2 = reshape(d2,M,N);
K = double(d2 < vq_distortion);

is_valid_ii = find(any(K,2));

K = K(is_valid_ii,any(K,1));
w0 = lp_vq(K);
w = rm_duplicate_motions(K,w0);

code_ind = find(w>0);
d2c = d2(:,code_ind);
[min_d2c,Gm] = min(d2c,[],2);

Gm(min_d2c > vq_distortion) = nan;
Gm = findgroups(Gm);

assert(sum(~isnan(Gm))==size(corresp,2), ...
       'You got problems buddy.');
