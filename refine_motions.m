function [res,stats] = refine_motions(u,Hinf0,u_corr,U,t,Rt,q0,cc)
u_corr = u_corr(u_corr.G_m > 0,:);

x_laf = [u(:,u_corr{:,'i'}) u(:,u_corr{:,'j'})];
x = reshape(x_laf,3,[]);
x = x(1:2,:);

[G_t,uG_t] = findgroups([u_corr.G_i]);
t0 = t(:,uG_t);

[G_m,uG_m] = findgroups(u_corr.G_m);
Rt0 = Rt(:,uG_m);

[G_app,uG_app] = findgroups(u_corr.G_app);
U0 = U(:,uG_app);

q_idx = 1;
linf_idx =  [1:3]+q_idx(end);
U_idx = [1:6*size(U0,2)]+linf_idx(end);
dt_idx = [1:numel(t0)]+U_idx(end);
drt_idx = [1:numel(Rt0)]+dt_idx(end);

dz0 = zeros(drt_idx(end),1);

idx = struct('params', struct('q', q_idx,'linf', linf_idx, ...
                              'U', U_idx, 't', dt_idx, ...
                              'Rt', drt_idx), ...
             'predict', struct('t',G_t,'Rt',G_m,'U',G_app));

err0 = errfun(dz0,idx,x,u_corr,cc,Hinf0,U0,t0,Rt0,q0);

%options = optimoptions('lsqnonlin','Display','iter','MaxIterations',10);
%[dz,resnorm,err] = lsqnonlin(@errfun,dz0,[],[],options, ...
%                             idx,x,u_corr,cc,Hinf0,U0,t0,Rt0,q0);
Jpat = make_Jpat(idx);

options = optimoptions('lsqnonlin','Display','iter', ...
                       'JacobPattern',Jpat);
[dz,resnorm,err] = lsqnonlin(@errfun,dz0,[],[],options, ...
                             idx,x,u_corr,cc,Hinf0,U0,t0,Rt0,q0);

[Hinf,U,t,Rt,q] = unwrap(dz,idx,Hinf0,U0,t0,Rt0,q0);

res = struct('Hinf', Hinf, 'U', U, 't', t, ...
             'Rt', Rt, 'q', q, 'cc',cc);
stats = struct('resnorm', resnorm, ...
               'err',err);

function err = errfun(dz,idx,x,u_corr,cc,Hinf0,U0,t0,Rt0,q0)
[Hinf,U,t,Rt,q] = unwrap(dz,idx,Hinf0,U0,t0,Rt0,q0);

y_ii = LAF.translate(U(:,idx.predict.U),t(:,idx.predict.t));
y_jj = LAF.translate(y_ii,Rt(:,idx.predict.Rt));

invH = inv(Hinf);
ylaf = LAF.renormI(blkdiag(invH,invH,invH)*[y_ii y_jj]);
yu = reshape(ylaf,3,[]);
yd = CAM.rd_div(yu(1:2,:),cc,q);
err = reshape(yd-x,[],1);

function [Hinf,U,t,Rt,q] = unwrap(dz,idx,Hinf0,U0,t0,Rt0,q0)
Hinf = Hinf0;

dq = dz(idx.params.q);
dlinf = dz(idx.params.linf);
dU = LAF.pt2x3_to_pt3x3(reshape(dz(idx.params.U),6,[]));
dti = reshape(dz(idx.params.t),2,[]);
dRt = reshape(dz(idx.params.Rt),2,[]);

q = q0+dq;
Hinf(3,:) = Hinf(3,:)+dlinf';
U = U0+dU;
t = t0+dti;
Rt = Rt0+dRt;

function Jpat = make_Jpat(idx)
M = 12*numel(idx.predict.Rt);
N = idx.params.Rt(end);

Jpat = sparse(M,N);

dq = idx.params.q;
dlinf = idx.params.linf;
dU = reshape(idx.params.U,6,[]);
dti = reshape(idx.params.t,2,[]);
dRt = reshape(idx.params.Rt,2,[]);

[dq_ii dq_jj] = meshgrid(1:M,dq);
[dlinf_ii dlinf_jj] = meshgrid(1:M,dlinf);

dU_ii = reshape(repmat([1:M],6,1),1,[]);
dU_jj = reshape(repmat(dU(:,idx.predict.U),6,2),1,[]);

dti_ii = reshape(repmat([1:M],2,1),1,[]);
dti_jj = reshape(repmat(dti(:,idx.predict.t),6,2),1,[]);

dRt_ii = reshape(repmat([1:M],2,1),1,[]);;
dRt_jj = reshape(repmat(dRt(:,idx.predict.Rt),6,2),1,[]);

ind = sub2ind(size(Jpat), ...
              [dq_ii dlinf_ii(:)' dU_ii dti_ii dRt_ii], ...
              [dq_jj dlinf_jj(:)' dU_jj dti_jj dRt_jj]);

Jpat(ind) = 1;
