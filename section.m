function [U,Rt,G_rti] = section(v,rtree,rvertices)
keyboard;
numx = max(rtree.Nodes.Gs);
for k = 1:rvertices
X = zeros(9,
Gs = 

keyboard;

%switch motion_model
%  case 't'
%    motion_solver = 'HG.laf2xN_to_txN';    
%  case 'Rt'
%    motion_solver = 'HG.laf2xN_to_RtxN';
%end
%
%Hinf = model.Hinf;
%v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*LAF.ru_div(u,model.cc,model.q));
%
%w = LAF.translate(v(:,M.i),-v(4:5,M.i));
%U = cmp_splitapply(@(w) w(:,1),w,M.G_u');
%[G_rti,uG_rti] = findgroups(M.i');
%G_rti = reshape(G_rti,[],1);
%
%Rt = ...
%    cmp_splitapply(@(G_u,G_i) ...
%                   { feval(motion_solver,[U(:,G_u(1));v(:,G_i(1))]) }, ...
%                   M.G_u,M.i,G_rti);
%Rt = [ Rt{:} ];
