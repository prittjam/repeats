%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function M = ao_est_Rt_from_np_lsqnonlin(u,s,M)
R0 = M(1:3,1:3);
c0 = -R0'*M(:,end);

unwrap = @(x,R,c) mtx_R_to_3x3(x(1:3))*R*[eye(3,3) (-c+x(4:6))];
err_fn = @(x,u,R,c) reshape(ao_reproj_err(u,unwrap(x,R,c)),[],1);

x0 = zeros(6,1);

options = optimset('Display', 'Off', ...
                   'Diagnostics', 'Off', ...
                   'MaxIter', 10);

x = lsqnonlin(err_fn, x0, [], [], ...
              options, ...
              u(:,s),R0,c0);

M = unwrap(x,R0,c0);

function R = mtx_R_to_3x3(r)
    q = norm(r); % angle of ration
    if (q == 0), 
        R = eye(3,3);
    else
        W = mtx_make_skew_3x3(r/q); 	
        R = (eye(3) + W*sin(q) + W^2*(1-cos(q)));
    end