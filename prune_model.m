function [u_corr,model,stats] = prune_model(u,corresp,model)
s = min([corresp.i corresp.j],[],2);
t = max([corresp.i corresp.j],[],2);

invH = inv(model.Hinf);

y_ii = LAF.apply_rigid_xforms(model.U(:,corresp.G_u), ...
                              model.Rt_i(:,corresp.G_i));
y_jj = LAF.apply_rigid_xforms(y_ii,[model.Rt_ij(:,corresp.G_ij)]);

y_ii = LAF.rd_div(LAF.renormI(blkdiag(invH,invH,invH)*y_ii), ...
                  model.cc,model.q);
y_jj = LAF.rd_div(LAF.renormI(blkdiag(invH,invH,invH)*y_jj), ...
                  model.cc,model.q);

w = sqrt(sum([y_jj(1:2,:)-y_ii(1:2,:)].^2));

[G,id] = findgroups([s;t]);
Gs = G(1:end/2);
Gt = G(end/2+1:end);
N = max([Gs;Gt]);

A = sparse([Gs;Gt],[Gt;Gs],[w w]',N,N);
G = graph(A,'OmitSelfLoops');
p = plot(G,'Layout','layered');
[T,pred] = minspantree(G,'Type','forest');
highlight(p,T);

sp = id(T.Edges.EndNodes(:,1));
tp = id(T.Edges.EndNodes(:,2));

keyboard;
ind = find(ismember([corresp.i corresp.j], [sp tp],'rows'));
rind = find(ismember([corresp.i corresp.j],[tp sp],'rows'));

u_corr = table;
u_corr = corresp(ind,:);
u_corr.inverted = false(numel(ind),1);

rt = corresp{rind,{'theta','tij','a11'}}';
rt = Rt.invert(rt);

ri = corresp(rind,:).j;
rj = corresp(rind,:).i;

u_corr = cat(1,u_corr, ...
             table(ri,rj,rt(1,:)',rt(2:3,:)',rt(4,:)', ...
                   corresp(rind,:).MotionModel, ...
                   true(numel(rind),1), ...
                   corresp(rind,:).G_u, ...
                   corresp(rind,:).G_i, ...
                   corresp(rind,:).G_ij, ...
                   'VariableNames', {'i','j','theta', ...
                    'tij','a11', 'MotionModel','inverted','G_u','G_i','G_ij'}));
