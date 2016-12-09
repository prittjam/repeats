function M = resection(u,G)
estimator = {};
reflect = [];
M = [];
uG = unique(G);
for g = uG
    iG = find(G==g);
    estimator = 'laf2xN_to_txN';
    [g_rt,g_ii,g_jj] = calc_pwise_xforms(u(:,iG),estimator);
    reflect = find(g_rt(1,:) < 0);
    g_rt(1:2,reflect) = -1*g_rt(1:2,reflect);
    [g_jj(reflect),g_ii(reflect)] = deal(g_ii(reflect),g_jj(reflect));
    estimators = cell(numel(g_ii),1);
    estimators(:) = { estimator };
    tmp = table(iG(g_ii)',iG(g_jj)',g_rt',estimators, ...
                'VariableNames',{'i','j','Rt','MotionModel'});
    M = [M;tmp];
end
M.MotionModel = categorical(M.MotionModel);

function [Rt,ii,jj] = calc_pwise_xforms(u,est_xform)
M = size(u,2);
[ii,jj] = itril([M M],-1);
Rt = feval(est_xform,[u(:,ii);u(:,jj)]);
