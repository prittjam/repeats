function E = eg_est_E_from_np_lsqnonlin(u,s,E0)
[Pa,Pb,Pc,Pd] = cam_get_4P_from_F(E0);
[~,M] = cam_get_2P_from_4P(u(:,s),Pa,Pb,Pc,Pd);

R0 = M(1:3,1:3);
c0 = -R0'*M(:,end);

unwrap = @(x,R,c) mtx_make_skew_3x3(-mtx_R_to_3x3(x(1:3))*R*(c+x(4:6)))*mtx_R_to_3x3(x(1:3))*R;
err_fn = @(x,u,R,c) reshape(eg_sampson_err(u,unwrap(x,R,c)),[],1);

x0 = zeros(6,1);

x = lsqnonlin(err_fn, x0, [], [], ...
              optimset('Display', 'Off', ...
                       'Diagnostics', 'Off', ...
                       'MaxIter', 3), ...
              u(:,s),R0,c0);

E = unwrap(x,R0,c0);

function R = mtx_R_to_3x3(r)
  q = norm(r); % angle of ration
  if (q == 0), 
      R = eye(3,3);
  else
      W = mtx_make_skew_3x3(r/q); 	
      R = (eye(3) + W*sin(q) + W^2*(1-cos(q)));
  end

