function [P1 P2 P3 P4] = cam_get_4P_from_F(G)
Gn = sqrt(2)*G/norm(G,'fro');
v = null(Gn);
V = mtx_make_skew_3x3(v);
ga = [Gn(:,1) Gn(:,2) Gn(:,3) ...
      cross(Gn(:,1),Gn(:,2)) cross(Gn(:,2),Gn(:,3)) cross(Gn(:,1),Gn(:,3))];
gb = [ -ga(:,1:3) ga(:,4:end) ];
va = [V(:,1) V(:,2) V(:,3) ...
      cross(V(:,1),V(:,2)) cross(V(:,2),V(:,3)) cross(V(:,1),V(:,3))];
piva = pinv(va);
R1 = ga*piva;
R2 = gb*piva;

P1 = R1*[eye(3,3) -v];
P2 = R1*[eye(3,3)  v];
P3 = R2*[eye(3,3) -v];
P4 = R2*[eye(3,3)  v];