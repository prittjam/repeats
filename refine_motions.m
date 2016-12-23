function [res,stats] = refine_motions(u,Hinf0,u_corr,U,ti,tij,theta,q0,cc)
u_corr = u_corr(u_corr.G_rt > 0,:);

x_laf = [u(:,u_corr{:,'i'}) u(:,u_corr{:,'j'})];
x = reshape(x_laf,3,[]);
x = x(1:2,:);

[G_ti,uG_ti] = findgroups([u_corr.G_i]);
ti0 = ti(:,uG_ti);

[G_tij,uG_tij] = findgroups(u_corr.G_rt);
tij0 = tij(:,uG_tij);

[G_app,uG_app] = findgroups(u_corr.G_app);
U0 = U(:,uG_app);

q_idx = 1;
H_idx =  [1:3]+q_idx(end);
U_idx = [1:6*size(U0,2)]+H_idx(end);
dti_idx = [1:numel(ti0)]+U_idx(end);
dtij_idx = [1:numel(tij0)]+dti_idx(end);

rtxn_idx = find(u_corr.MotionModel == 'laf2xN_to_RtxN');
[G_theta,uG_theta] = findgroups(u_corr(rtxn_idx,:).MotionModel);

theta0 = theta;

if isempty(rtxn_idx)
    dtheta_idx = [];
    G_theta = [];
    RtxN_idx = []; 
    dz0 = zeros(dtij_idx(end),1);
else
    [G_theta,uG_theta] = findgroups(G_tij(rtxn_idx));
    num_theta = numel(uG_theta);
    dtheta_idx = [1:num_theta]+dtij_idx(end);
    dz0 = zeros(dtheta_idx(end),1);
end

idx = ...
    struct('fit', struct('q', q_idx,'H', H_idx, ...
                         'U', U_idx, 'ti', dti_idx, ...
                         'tij', dtij_idx,'theta',dtheta_idx, ...
                         'active', struct('theta', uG_theta)), ...
           'predict', struct('ti',G_ti,'tij',G_tij, ...
                             'theta',G_theta,'Rt', G_tij, ...
                             'U',G_app, ...
                             'active',struct('theta',rtxn_idx)));

err0 = errfun(dz0,idx,x,u_corr,cc,Hinf0,U0,ti0,tij0,theta0,q0);

Jpat = make_Jpat(idx);

options = optimoptions('lsqnonlin','Display','iter', ...
                       'JacobPattern',Jpat);
[dz,resnorm,err] = lsqnonlin(@errfun,dz0,[],[],options, ...
                             idx,x,u_corr,cc,Hinf0,U0,ti0,tij0,theta0,q0);

[Hinf,U,ti,tij,theta,q] = unwrap(dz,idx,Hinf0,U0,ti0,tij0,theta0,q0);

res = struct('Hinf', Hinf, 'U', U, 'ti', ti, ...
             'tij', tij, 'q', q, 'cc',cc);
stats = struct('resnorm', resnorm, ...
               'err',err);

function err = errfun(dz,idx,x,u_corr,cc,Hinf0,U0,ti0,tij0,theta0,q0)
[Hinf,U,ti,tij,theta,q] = unwrap(dz,idx,Hinf0,U0,ti0,tij0,theta0,q0);

yi = LAF.translate(U(:,idx.predict.U),ti(:,idx.predict.ti));
yj = LAF.apply_rigid_xforms(yi,theta(idx.predict.Rt),...
                            tij(:,idx.predict.tij));

invH = inv(Hinf);
ylaf = LAF.renormI(blkdiag(invH,invH,invH)*[yi yj]);
yu = reshape(ylaf,3,[]);
yd = CAM.rd_div(yu(1:2,:),cc,q);
err = reshape(yd-x,[],1);

function [Hinf,U,ti,tij,theta,q] = unwrap(dz,idx,Hinf0,U0,ti0,tij0,theta0,q0)
Hinf = Hinf0;

dq = dz(idx.fit.q);
dH = dz(idx.fit.H);
dU = LAF.pt2x3_to_pt3x3(reshape(dz(idx.fit.U),6,[]));
dti = reshape(dz(idx.fit.ti),2,[]);
dtij = reshape(dz(idx.fit.tij),2,[]);
dtheta = reshape(dz(idx.fit.theta),1,[]);

q = q0+dq;

if isempty(idx.fit.theta)    
    Hinf(3,:) = Hinf(3,:)+dH';
else
    Hinf = [1+dh(1) dh(2) dh(3);dh(4) 1+dh(5) dh(6); dh(7) dh(8) 1]*Hinf0;
end
    
U = U0+dU;
ti = ti0+dti;
tij = tij0+dtij;
theta = theta0;

theta(idx.fit.active.theta) = theta0(idx.fit.active.theta)+dtheta;

function Jpat = make_Jpat(idx)
K = numel(idx.predict.Rt);
M = 12*K;

if isempty(idx.fit.theta)
    N = idx.fit.tij(end);
else
    N = idx.fit.theta(end);
end

Jpat = sparse(M,N);

dq = idx.fit.q;
dH = idx.fit.H;
dU = reshape(idx.fit.U,6,[]);
dti = reshape(idx.fit.ti,2,[]);
dtij = reshape(idx.fit.tij,2,[]);
dtheta = idx.fit.theta;

[dq_ii dq_jj] = meshgrid(1:M,dq);
[dH_ii dH_jj] = meshgrid(1:M,dH);

dU_ii = reshape(repmat([1:M],6,1),1,[]);
dU_jj = reshape(repmat(dU(:,idx.predict.U),6,2),1,[]);

dti_ii = reshape(repmat([1:M],2,1),1,[]);
dti_jj = reshape(repmat(dti(:,idx.predict.ti),6,2),1,[]);

dtij_ii = reshape(repmat([1:M],2,1),1,[]);;
dtij_jj = reshape(repmat(dtij(:,idx.predict.tij),6,2),1,[]);

tmp = reshape([1:M],6,[]);
active_theta = [idx.predict.active.theta;idx.predict.active.theta+K];
dtheta_ii = reshape(tmp(:,active_theta),1,[]);
dtheta_jj = reshape(repmat(dtheta(idx.predict.theta),6,2),1,[]);

ind = sub2ind(size(Jpat), ...
              [dq_ii dH_ii(:)' dU_ii dti_ii dtij_ii dtheta_ii], ...
              [dq_jj dH_jj(:)' dU_jj dti_jj dtij_jj dtheta_jj]);
Jpat(ind) = 1;
