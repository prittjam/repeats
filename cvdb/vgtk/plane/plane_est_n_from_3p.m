function n = plane_est_n_from_3p(u,s,varargin)
inl = find(s);
v = cross(u(:,inl(2))-u(:,inl(1)), ...
          u(:,inl(3))-u(:,inl(1)));
vn = v./norm(v);
n = [vn; -dot(vn,u(:,inl(1)))];