function [u_corr,model] = get_valid_motions(u_corr0,model0)
u_corr = u_corr0(u_corr0.G_ij > 0,:);

[G_u,uG_u] = findgroups(u_corr.G_u);
[G_i,uG_i] = findgroups(u_corr.G_i);
[G_ij,uG_ij] = findgroups(u_corr.G_ij);

u_corr.G_u = G_u;
u_corr.G_i = G_i;
u_corr.G_ij = G_ij;

model = model0;
model.U = model0.U(:,uG_u);
model.Rt_i = model0.Rt_i(:,uG_i);
model.Rt_ij = model0.Rt_ij(:,uG_ij);
