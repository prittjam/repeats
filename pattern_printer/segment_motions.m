%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [rt2,Gm,needs_inverted] = segment_motions(x,model,corresp,rt,vqT)
cfg.num_codes = 1e3;

Hinf = model.H;
Hinv = inv(Hinf);

xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,model.cc, ...
                                                  model.q));

M = size(corresp,2);
%if M > cfg.num_codes
%    ind = randsample(M,cfg.num_codes);
%else
ind = 1:M;
    %end

N = numel(ind);

[aa,bb] = ndgrid(1:M,1:N);

c1 = corresp(1,aa);
c2 = corresp(2,aa);

ut_j = LAF.rd_div(PT.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                              PT.apply_xforms(xp(:,c1),rt(:,:,bb))),...
                  model.cc,model.q);
invrt = multinv(rt);
ut_i = LAF.rd_div(PT.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                              PT.apply_xforms(xp(:,c2), ...
                                              invrt(:,:,bb))),...
                  model.cc,model.q);
d2 = sum([ut_j-x(:,c2);  ...
          ut_i-x(:,c1)].^2);
d2 = reshape(d2,M,N);
K = double(d2 < vqT);

is_valid_ii = find(any(K,2));

K = K(is_valid_ii,any(K,1));
w0 = lp_vq(K);
w = rm_duplicate_motions(K,w0);

code_ind = find(w>0);
d2c = d2(:,code_ind);
[min_d2c,Gm] = min(d2c,[],2);

Gm(min_d2c > vqT) = nan;

%assert(all(min_d2c < vqT), ...
%       'Motion segmentation increased error.');
%assert(sum(~isnan(Gm))==size(corresp,2), ...
%       'Some correspondences dont have motions.');

uGm = unique(Gm);
Gm = findgroups(Gm);
rt2 = rt(:,:,uGm);

needs_inverted = unique_ro(rt2);
rt2(:,:,needs_inverted) = multinv(rt2(:,:,needs_inverted));