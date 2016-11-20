function [corresp,X,Rt] = segment_motions(dr,G_app)
rt = [];
ii = [];
jj = [];
reflect = [];

uG = unique(G_app);
for g = uG
    iG = find(G_app==g);
    [g_rt,g_ii,g_jj] = calc_pwise_xforms(v(:,iG),'laf2xN_to_RtxN');
    rt = cat(2,rt,g_rt);
    ii = cat(2,ii,iG(g_ii));
    jj = cat(2,jj,iG(g_jj));
end

reflect = cat(2,reflect,find(rt(2,:) < 0));
rt(2:3,reflect) = -1*rt(2:3,reflect);
[jj(reflect),ii(reflect)] = deal(ii(reflect),jj(reflect));

t_ij = [rt(2,:); rt(3,:)];
meanshift = MMS.Meanshift('manifold','R2', ...
                          'bandwidth_type','sample', ...
                          'pilot_knn',5,'min_support',5);
[rt,G_rt] = meanshift.fit_and_predict(t_ij);
meanshift.delete();

t_i = v(4:5,ii);
corresp = table(G_rt',G_app(ii)',ii',jj',t_i',t_ij', ...
                'VariableNames',{'G_rt','G_app','ii','jj','t_i','t_ij'});

[GG,uGG] = findgroups(corresp(:,{'G_rt','G_app'}));
X0 = cmp_splitapply(@(v) v(:,1), ...
                    LAF.apply_rigid_xforms(v(:,ii),0,-t_i),GG');  

X = table(uGG{:,1},uGG{:,2},X0', ...
          'VariableNames',{'G_rt','G_app','X0'});
Rt = table([1:size(rt,2)]',rt', ...
           'VariableNames', {'G_rt','Rt'});