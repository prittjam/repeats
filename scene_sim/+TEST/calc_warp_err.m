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

function [v,A] = do_hartley(u)
v = reshape(u,3,[]);
v = PT.renormI(v);

tx = mean(v(1,:));
ty = mean(v(2,:));
v(1,:) = v(1,:) - tx;
v(2,:) = v(2,:) - ty;
dsc = max(max(abs(v(1:2,:)),[],2));
v(1:2,:) = v(1:2,:)/dsc;

v = reshape(v,6,[]);

A = eye(3);
A([1,2],3) = -[tx ty] / dsc;
A(1,1) = 1 / dsc;
A(2,2) = 1 / dsc;

function [X] = whiten(X,fudgefactor)
X = [rand(2,4)];
muX = mean(X,2);
mX = X-muX;
S = mX*mX'/size(mX,2);
[U,S,V] = svd(S);
M = [U*diag(1./sqrt(diag(S)))*U' -muX; 
     0 0 1];
Y = M*[X;ones(1,4)];
keyboard;