function [u_corr,U,Rt_i,Rt_ij] = get_valid_motions(u_corr0,U0,Rt0_i,Rt0_ij)
u_corr = u_corr0(u_corr0.G_ij > 0,:);

[u_corr.G_u,uG_u] = findgroups(u_corr.G_u);
[u_corr.G_i,uG_i] = findgroups(u_corr.G_i);
[u_corr.G_ij,uG_ij] = findgroups(u_corr.G_ij);

U = U0(:,uG_u);
Rt_i = Rt0_i(:,uG_i);
Rt_ij = Rt0_ij(:,uG_ij);
