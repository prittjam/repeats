%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [cspond,Rtij] = resection(xp,cspond,motion_model,vqT)
switch motion_model
  case 't'
    motion_solver = 'HG.laf2xN_to_txN';    
  case 'Rt'
    motion_solver = 'HG.laf2xN_to_RtxN';
end
%xform_list = ...
%    cmp_splitapply(@(xp,ind) ...
%                   deal( { laf2xNxN_to_RtxNxN(xp,ind,motion_solver,true) }), ...
%                   xp,1:size(xp,2),G);
%xform_list = [xform_list{:}];
%cspond = [xform_list(:).i; xform_list(:).j];
%Rtij = reshape([xform_list(:).Rt],3,3,[]);

rt = feval(motion_solver,[xp(:,cspond(1,:));xp(:,cspond(2,:))]);
Rtij = Rt.params_to_mtx(rt);



%function xform_list = laf2xNxN_to_RtxNxN(x,ind,motion_solver,do_inversion)
%N = size(x,2);
%[ii,jj] = itril([N N],-1);
%rt = feval(motion_solver,[x(:,ii);x(:,jj)]);
%mtxRt = Rt.params_to_mtx(rt);
%xform_list = struct('Rt', reshape(squeeze(mat2cell(mtxRt,3,3,ones(1, ...
%                                                  size(mtxRt,3)))),1,[]), ....
%                    'i', mat2cell(ind(ii),1,ones(1,numel(ii))), ...
%                    'j', mat2cell(ind(jj),1,ones(1,numel(jj))));