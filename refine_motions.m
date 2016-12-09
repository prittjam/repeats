function res = refine_motions(u,Hinf0,u_corr,U,t_i,Rt,q0,cc)
u_corr = u_corr(u_corr.G_m > 0,:);

x = reshape([u(:,u_corr{:,'i'}) u(:,u_corr{:,'j'})],3,[]);
x = x(1:2,:);

[G_t,uG_t] = findgroups(u_corr.G_m);
t_i = t_i(:,uG_t);
dti_count = 2*size(t_i,2);

[G_m,uG_m] = findgroups(u_corr.G_m);
Rt = Rt(:,uG_m);
drt_count = 2*numel(uG_m);

[G_app,uG_app] = findgroups(u_corr.G_app');
U = U(:,uG_app);
dU_count = 6*numel(uG_app);

q_idx = 1;
linf_idx =  [1:3]+q_idx(end);
U_idx = [1:dU_count]+linf_idx(end);
dti_idx = [1:dti_count]+U_idx(end);
drt_idx = [1:drt_count]+dti_idx(end);

dz0 = zeros(drt_idx(end),1);

idx = struct('params', struct('q', q_idx,'linf', linf_idx, ...
                              'U', U_idx, 'ti', dti_idx, ...
                              'Rt', drt_idx), ...
             'predict', struct('t_i',G_t,'Rt',G_m, ...
                               'U', G_app));

err0 = errfun(dz0,idx,x,Hinf0,u_corr,U,t_i,Rt,q0,cc);

options = optimoptions('lsqnonlin','Display','iter', ...
                       'MaxIterations',3);

[dz,resnorm,err] = lsqnonlin(@errfun,dz0,[],[],options, ...
                             idx,x,Hinf0,u_corr,U,t_i,Rt,q0,cc);
dq = dz(idx.params.q);
dlinf = dz(idx.params.linf);

q = q0+dq;

Hinf = Hinf0;
Hinf(3,:) = Hinf(3,:)+dlinf';

res = struct('Hinf', Hinf,'q', q);

function err = errfun(dz,idx,x,Hinf0,u_corr,U,t_i,Rt,q0,cc)
Hinf = Hinf0;

dq = dz(idx.params.q);
dlinf = dz(idx.params.linf);
dU = LAF.pt2x3_to_pt3x3(reshape(dz(idx.params.U),6,[]));
dti = reshape(dz(idx.params.ti),2,[]);
dRt = reshape(dz(idx.params.Rt),2,[]);

q = q0+dq;
Hinf(3,:) = Hinf(3,:)+dlinf';
U = U+dU;
t_i = t_i+dti;
Rt = Rt+dRt;

y_ii = LAF.translate(U(:,idx.predict.U),t_i(:,idx.predict.t_i));
y_jj = LAF.translate(y_ii,Rt(:,idx.predict.Rt));

invH = inv(Hinf);
ylaf = LAF.renormI(blkdiag(invH,invH,invH)*[y_ii y_jj]);
y = reshape(ylaf,3,[]);
%y = CAM.distort(yp(1:2,:),cc,q);

err = reshape(y-x,[],1);
