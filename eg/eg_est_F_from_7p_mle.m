function F = eg_est_F_from_7p_mle(u,F0,W)
m = 4*size(u,2);

if nargin < 3
    W = ones(m,1);
end

[U0,S,V0] = svd(F0);
%s0 = [acos(S(1,1)) acos(S(2,2))];
s0 = S(2,2)/S(1,1);

unwrap = @(x,U0,s0,V0) ...
         mtx_R_to_3x3(x(1:3))*U0* ...
         diag([1 s0+x(4) 0])* ...
         mtx_R_to_3x3(x(5:7))*V0';

err_fn = @(x,u,U0,s0,V0,W) reshape(bsxfun(@times,sqrt(W'),eg_sampson_F_dist(u,unwrap(x,U0,s0,V0))),[],1);

x0 = zeros(7,1);

options = optimset('Display', 'Off', ...
                   'Diagnostics', 'Off');

x = lsqnonlin(err_fn, x0, [], [], ...
              options, ...
              u,U0,s0,V0,W);
F = unwrap(x,U0,s0,V0);

function R = mtx_R_to_3x3(r)
    q = norm(r); % angle of ration
    if (q == 0), 
        R = eye(3,3);
    else
        W = mtx_make_skew_3x3(r/q); 	
        R = (eye(3) + W*sin(q) + W^2*(1-cos(q)));
    end
