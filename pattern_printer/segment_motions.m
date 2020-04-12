%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [rt2,Gm,is_inverted] = segment_motions(x,model,cspond,rt,vqT)
cfg.num_codes = 2e3;

Hinf = model.H;
Hinv = inv(Hinf);

xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,model.cc, ...
                                                  model.q));
if size(rt,3) > cfg.num_codes
    ind = randsample(size(rt,3),cfg.num_codes);
    rt = rt(:,:,ind);
end

M = size(cspond,2);
N = size(rt,3); 
is_inverted = unique_ro(rt);

cspond([2 1],is_inverted) = cspond(:,is_inverted);
rt(:,:,is_inverted) = multinv(rt(:,:,is_inverted));

ut_j = PT.rd_div(PT.renormI(blkdiag(Hinv,Hinv,Hinv)*...
                            PT.multiprod(rt,xp(:,cspond(1,:)))), ...
                            model.cc,model.q);
invrt = multinv(rt);
ut_i = PT.rd_div(PT.renormI(blkdiag(Hinv,Hinv,Hinv)*...
                            PT.multiprod(invrt,xp(:,cspond(2,:)))), ...
                            model.cc,model.q);

err1 = reshape(ut_j,9,M,N)-x(:,cspond(2,:));
err2 = reshape(ut_i,9,M,N)-x(:,cspond(1,:));

d2 = sum([err1;err2].^2);
d2 = reshape(d2,M,N);

K = sparse(double(d2 < vqT));
is_valid_ii = find(any(K,2));
K = K(is_valid_ii,any(K,1));
w0 = lp_vq(K);
w = rm_duplicate_motions(K,w0);

code_ind = find(w>0);
d2c = d2(:,code_ind);
rt = rt(:,:,code_ind);
[min_d2c,Gm] = min(d2c,[],2);

Gm(min_d2c > vqT) = nan;

uGm = unique(Gm(~isnan(Gm)));
rt2 = rt(:,:,uGm);
Gm = findgroups(Gm);

%assert(all(min_d2c < vqT), ...
%       'Motion segmentation increased error.');
%assert(sum(~isnan(Gm))==size(cspond,2), ...
%       'Some cspondondences dont have motions.');
%check_err(x,cspond,rt2(:,:,Gm),model,vqT,is_inverted);

function d2 = check_err(x,cspond,Rtij,model0,vqT,is_inverted)
Hinf = model0.H;
Hinv = inv(Hinf);
Rtij(:,:,end) = inv(Rtij(:,:,end));
xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,model0.cc,model0.q));
Rtij(:,:,end) = inv(Rtij(:,:,end));
ut_j =  PT.rd_div(PT.renormI( ...
    PT.mtimesx(multiprod(Hinv,Rtij),xp(:,cspond(1,:)))),...
                  model0.cc,model0.q);

invRtij = multinv(Rtij);

ut_i =  PT.rd_div(PT.renormI( ...
    PT.mtimesx(multiprod(Hinv,invRtij),xp(:,cspond(2,:)))), ...
                  model0.cc,model0.q);
locald2 = sum([ut_j-x(:,cspond(2,:)); ...
               ut_i-x(:,cspond(1,:))].^2);
inl = find(double(locald2 < vqT));
assert(numel(inl)==size(cspond,2), ...
       'Error did not increase');