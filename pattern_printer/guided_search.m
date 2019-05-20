function [] = guided_search(x,model,cspond,rt,vqT)
cfg.num_codes = 1e3;

Hinf = model.H;
Hinv = inv(Hinf);

xp = ...
    PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,model.cc,model.q));

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

code_ind = find(w>0);
d2c = d2(:,code_ind);
rt = rt(:,:,code_ind);
[min_d2c,Gm] = min(d2c,[],2);

Gm(min_d2c > vqT) = nan;

uGm = unique(Gm(~isnan(Gm)));
rt2 = rt(:,:,uGm);
Gm = findgroups(Gm);