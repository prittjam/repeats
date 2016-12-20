function [res,stats] = refine_motions(u,Hinf0,u_corr,U,ti,tij,theta,q0,cc)
u_corr = u_corr(u_corr.G_m > 0,:);

x_laf = [u(:,u_corr{:,'i'}) u(:,u_corr{:,'j'})];
x = reshape(x_laf,3,[]);
x = x(1:2,:);

[G_t,uG_t] = findgroups([u_corr.G_i]);
ti0 = ti(:,uG_t);

[G_m,uG_m] = findgroups(u_corr.G_m);
active_theta_idx = unique(G_m(u_corr.MotionModel == 'laf2xN_to_RtxN'));

tij0 = tij(:,uG_m);
theta0 = theta(:,uG_m);

[G_app,uG_app] = findgroups(u_corr.G_app);
U0 = U(:,uG_app);

q_idx = 1;
linf_idx =  [1:3]+q_idx(end);
U_idx = [1:6*size(U0,2)]+linf_idx(end);
dti_idx = [1:numel(ti0)]+U_idx(end);
dtij_idx = [1:numel(tij0)]+dti_idx(end);

if isempty(active_theta_idx)
    dtheta_idx = [];
    dz0 = zeros(dtij_idx(end),1);
else
    dtheta_idx = [1:numel(active_theta_idx)+dtij_idx(end)];
    dz0 = zeros(dtheta_idx(end),1);
end

idx = ...
    struct('params', struct('q', q_idx,'linf', linf_idx, ...
                            'U', U_idx, 'ti', dti_idx, ...
                            'tij', dtij_idx,'theta',dtheta_idx, ...
                            'active_theta', active_theta_idx), ...
           'predict', struct('ti',G_t,'theta',G_m, ...
                             'tij',G_m,'U',G_app));

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
yj = LAF.apply_rigid_xforms(yi,theta0(idx.predict.theta),...
                            tij(:,idx.predict.tij));

invH = inv(Hinf);
ylaf = LAF.renormI(blkdiag(invH,invH,invH)*[yi yj]);
yu = reshape(ylaf,3,[]);
yd = CAM.rd_div(yu(1:2,:),cc,q);
err = reshape(yd-x,[],1);

function [Hinf,U,ti,tij,theta,q] = unwrap(dz,idx,Hinf0,U0,ti0,tij0,theta0,q0)
Hinf = Hinf0;

dq = dz(idx.params.q);
dlinf = dz(idx.params.linf);
dU = LAF.pt2x3_to_pt3x3(reshape(dz(idx.params.U),6,[]));
dti = reshape(dz(idx.params.ti),2,[]);
dtij = reshape(dz(idx.params.tij),2,[]);
dtheta = dz(idx.params.theta);

q = q0+dq;
Hinf(3,:) = Hinf(3,:)+dlinf';
U = U0+dU;
ti = ti0+dti;
tij = tij0+dtij;
theta = theta0;

if ~isempty(dtheta);
    theta(active_theta_idx) = theta0+dtheta;
end

function Jpat = make_Jpat(idx)
M = 12*numel(idx.predict.tij);
N = idx.params.tij(end);

Jpat = sparse(M,N);

dq = idx.params.q;
dlinf = idx.params.linf;
dU = reshape(idx.params.U,6,[]);
dti = reshape(idx.params.ti,2,[]);
dtij = reshape(idx.params.tij,2,[]);

[dq_ii dq_jj] = meshgrid(1:M,dq);
[dlinf_ii dlinf_jj] = meshgrid(1:M,dlinf);

dU_ii = reshape(repmat([1:M],6,1),1,[]);
dU_jj = reshape(repmat(dU(:,idx.predict.U),6,2),1,[]);

dti_ii = reshape(repmat([1:M],2,1),1,[]);
dti_jj = reshape(repmat(dti(:,idx.predict.ti),6,2),1,[]);

dtij_ii = reshape(repmat([1:M],2,1),1,[]);;
dtij_jj = reshape(repmat(dtij(:,idx.predict.tij),6,2),1,[]);

ind = sub2ind(size(Jpat), ...
              [dq_ii dlinf_ii(:)' dU_ii dti_ii dtij_ii], ...
              [dq_jj dlinf_jj(:)' dU_jj dti_jj dtij_jj]);

Jpat(ind) = 1;
