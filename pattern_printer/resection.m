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

rt = feval(motion_solver,[xp(:,cspond(1,:));xp(:,cspond(2,:))]);
Rtij = Rt.params_to_mtx(rt);
