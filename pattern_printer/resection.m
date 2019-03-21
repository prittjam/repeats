%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [cspond,Rtij,inl] = resection(x,model0,G,motion_model,vqT)
switch motion_model
  case 't'
    motion_solver = 'HG.laf2xN_to_txN';    
  case 'Rt'
    motion_solver = 'HG.laf2xN_to_RtxN';
end
Hinf = model0.H;
Hinv = inv(model0.H);

l = transpose(model0.H(3,:));

xu = PT.ru_div(x,model0.cc,model0.q);
[~,side] = PT.are_same_orientation(xu,l);

xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*xu);
xform_list = ...
    cmp_splitapply(@(xp,ind) ...
                   deal( { laf2xNxN_to_RtxNxN(xp,ind,motion_solver,true) }), ...
                   xp,1:size(xp,2),G);
xform_list = [xform_list{:}];
cspond = [xform_list(:).i; xform_list(:).j];

Rtij = reshape([xform_list(:).Rt],3,3,[]);
invRtij = multinv(Rtij);
ut_j =  PT.rd_div(PT.renormI( ...
    PT.mtimesx(multiprod(Hinv,Rtij),xp(:,cspond(1,:)))),model0.cc,model0.q);
ut_i =  PT.rd_div(PT.renormI( ...
    PT.mtimesx(multiprod(Hinv,invRtij),xp(:,cspond(2,:)))),model0.cc,model0.q);
d2 = sum([ut_j-x(:,cspond(2,:)); ...
          ut_i-x(:,cspond(1,:))].^2);
d2inl = find(d2 < vqT);
sides = side(cspond(:,d2inl));
[~,best_side] = max(hist(sides(:),[1,2]));
side_inl =  find(all(sides == best_side));

inl = d2inl(side_inl);

inlx = unique(cspond(:,inl));
[are_same,side] = PT.are_same_orientation(xu(:,inlx),l);
assert(are_same, ...
       ['There are measurements on both sides of the vanishing line!']);


function xform_list = laf2xNxN_to_RtxNxN(x,ind,motion_solver,do_inversion)
N = size(x,2);
[ii,jj] = itril([N N],-1);
rt = feval(motion_solver,[x(:,ii);x(:,jj)]);
mtxRt = Rt.params_to_mtx(rt);
xform_list = struct('Rt', reshape(squeeze(mat2cell(mtxRt,3,3,ones(1, ...
                                                  size(mtxRt,3)))),1,[]), ....
                    'i', mat2cell(ind(ii),1,ones(1,numel(ii))), ...
                    'j', mat2cell(ind(jj),1,ones(1,numel(jj))));