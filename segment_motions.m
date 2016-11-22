function [corresp,X,Rt] = segment_motions(u,G_app)
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

meanshift = MMS.Meanshift('manifold','R2', ...
                          'bandwidth_type','sample', ...
                          'pilot_knn',5,'min_support',5);
t_ij = rt;
[rt,G_rt] = meanshift.fit_and_predict(t_ij);
meanshift.delete();

t_i = u(4:5,ii);
corresp = table(G_rt',G_app(ii)',ii',jj',t_i',t_ij', ...
                'VariableNames',{'G_rt','G_app','ii','jj','t_i','t_ij'});

[GG,uGG] = findgroups(corresp(:,{'G_rt','G_app'}));
X0 = cmp_splitapply(@(u) u(:,1), ...
                    LAF.apply_rigid_xforms(u(:,ii),0,-t_i),GG');  

X = table(uGG{:,1},uGG{:,2},X0', ...
          'VariableNames',{'G_rt','G_app','X0'});
Rt = table([1:size(rt,2)]',rt', ...
           'VariableNames', {'G_rt','Rt'});

function [Rt,ii,jj] = calc_pwise_xforms(u,est_xform)
M = size(u,2);
[ii,jj] = find(tril(ones(M,M),-1));
Rt = feval(est_xform,[u(:,ii);u(:,jj)]);