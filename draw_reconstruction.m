function [] = draw_reconstruction(u,u_corr,Hinf,M,U,t_i,Rt)
inl = ~isnan(M.G_m);
M = M(inl,:);
idx = struct('predict', struct('t_i',M.G_t, ...
                               'Rt',M.G_m, ...
                               'U', M.G_app));
y_ii = LAF.translate(U(:,idx.predict.U),t_i(:,idx.predict.t_i));
y_jj = LAF.translate(y_ii,Rt(:,idx.predict.Rt));
y_ii = LAF.renormI(blkdiag(inv(Hinf),inv(Hinf),inv(Hinf))*y_ii);
for k = 1:10
    figure;
    LAF.draw(gca,u(:,u_corr{k,'i'}),'LineStyle','--');
    LAF.draw(gca,y_ii(:,k));
end

