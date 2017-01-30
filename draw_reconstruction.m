function [] = draw_reconstruction(u,u_corr,Hinf,M,U,ti,theta,tij)
inl = ~isnan(M.G_rt);
M = M(inl,:);
invH = inv(Hinf);
idx = struct('predict', struct('ti',M.G_i, ...
                               'Rt',M.G_rt, ...
                               'U', M.G_app));

y_ii = LAF.translate(U(:,idx.predict.U),ti(:,idx.predict.ti));
y_jj = LAF.apply_rigid_xforms(y_ii,theta(idx.predict.Rt), ...
                              tij(:,idx.predict.Rt));

y_ii = LAF.renormI(blkdiag(invH,invH,invH)*y_ii);
y_jj = LAF.renormI(blkdiag(invH,invH,invH)*y_jj);

u_corr = u_corr(u_corr.G_rt > 0,:);

k1 = ceil(4/5*height(u_corr));
rng = k1+[1:9];
k2 = 0;

figure;
for k = rng
    k2 = k2+1;
    subplot(3,3,k2);
    LAF.draw(gca,u(:,u_corr{k,'i'}),'LineStyle','--');
    LAF.draw(gca,y_ii(:,k));
    LAF.draw(gca,u(:,u_corr{k,'j'}),'Color','r','LineStyle','--');
    LAF.draw(gca,y_jj(:,k),'Color','r');
    title(['(' num2str(u_corr{k,'i'}) ', ' ...
           num2str(u_corr{k,'j'}) ')']);
    axis equal;
end

keyboard;
