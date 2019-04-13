function rms = calc_warp_err(x,gtlinf,gtlambda,estlinf,estlambda,cc)
N = size(x,2);

gtlinf = gtlinf/gtlinf(3);
estlinf = estlinf/estlinf(3);

gtHinf = [1 0 0;0 1 0;gtlinf'];
estHinf = [1 0 0; 0 1 0;estlinf'];

xu = CAM.ru_div(x,cc,gtlambda);

%mu_xu = [mean(xu,2);1];
%mu_d = sqrt(sum([bsxfun(@minus,xu,mu)].^2));
%sc = sqrt(2)/mu_d;

A0 = calc_A0(xu,gtHinf,estHinf);
y = CAM.rd_div(PT.renormI(inv(estHinf)*A0*gtHinf*xu),cc,estlambda);
y = real(y);

options = optimoptions('lsqnonlin', ...
                       'Display','off', ...
                       'MaxIter',3);
[~,resnorm] = lsqnonlin(@errfun,zeros(6,1),[],[],options, ...
                        x,xu,A0,gtHinf,estHinf,estlambda, ...
                        cc);

rms = sqrt(1/2/N*resnorm);

function err = errfun(dA,x,xu,A0,gtHinf,estHinf,estlambda,cc)
A = A0+[reshape(dA,2,3); 0 0 0];
y = CAM.rd_div(PT.renormI(inv(estHinf)*A*gtHinf*xu),cc,estlambda);
err = [y-x];
err = reshape(err(1:2,:),[],1);

function A = calc_A0(x,gtHinf,estHinf)
u = x(1,:)';
v = x(2,:)';

xp = PT.renormI(gtHinf*x);
up = xp(1,:)';
vp = xp(2,:)';

h7 = estHinf(3,1);
h8 = estHinf(3,2);

M = ...
    [(up+h7*u.*up) (vp+h7*u.*vp) (h7*u+1) (h8*u.*up) (h8*u.*vp) (h8*u) ; ...
     (h7*up.*v)  (h7*v.*vp)  (h7*v)  (up+h8*up.*v)  (vp+h8*v.*vp) ...
     (h8*v+1)];

aa = pinv(M)*[u;v];

A = [aa(1:3)'; ...
     aa(4:6)'; ...
     0 0 1];
