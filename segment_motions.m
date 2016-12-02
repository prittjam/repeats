function [u_corr,U,t_i,Rt] = segment_motions(u,G_app,Hinf)
rt = [];
ii = [];
jj = [];
reflect = [];

uG = unique(G_app);
for g = uG
    iG = find(G_app==g);
    [g_rt,g_ii,g_jj] = calc_pwise_xforms(u(:,iG),'laf2xN_to_txN');
    rt = cat(2,rt,g_rt);
    ii = cat(2,ii,iG(g_ii));
    jj = cat(2,jj,iG(g_jj));
end

reflect = find(rt(1,:) < 0);
rt(1:2,reflect) = -1*rt(1:2,reflect);
[jj(reflect),ii(reflect)] = deal(ii(reflect),jj(reflect));

%meanshift = MMS.Meanshift('manifold','R2', ...
%                          'bandwidth_type','sample', ...
%                          'pilot_knn',20,'min_support',5);
%t_ij = rt;
%[rt,G_rt] = meanshift.fit_and_predict(t_ij);
%meanshift.delete();

cluster_xforms(u,ii,jj,rt,Hinf);

t_i = table([1:size(u,2)]',[u(4:5,:)]', ...
            'VariableNames',{'i','t_i'});
u_corr = table(G_rt',G_app(ii)',ii',jj',t_ij', ...
               'VariableNames',{'G_rt','G_app','i','j','t_ij'});

%[GG,uGG] = findgroups(corresp(:,{'G_rt','G_app'}));
[GG,uGG] = findgroups(u_corr(:,{'G_app'}));
U = cmp_splitapply(@(u) u(:,1), ...
                    LAF.apply_rigid_xforms(u(:,ii),0,-t_i{ii,'t_i'}'),GG'); 
%U = table(uGG{:,1},uGG{:,2},U', ...
%          'VariableNames',{'G_rt','G_app','U'});
U = table(uGG{:,1}, U', 'VariableNames',{'G_app','U'});
Rt = table([1:size(rt,2)]',rt', ...
           'VariableNames', {'G_rt','Rt'});

function [Rt,ii,jj] = calc_pwise_xforms(u,est_xform)
M = size(u,2);
[ii,jj] = find(tril(ones(M,M),-1));
Rt = feval(est_xform,[u(:,ii);u(:,jj)]);
