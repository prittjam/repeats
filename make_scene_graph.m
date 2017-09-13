function [dG,rvertices] = make_scene_graph(v,Gapp,Gm,xform_list)
num_nodes = numel(Gapp);
node_table = table(Gapp',nan(num_nodes,1), ...
                   repmat([0 0 0 1],num_nodes,1), ...
                   'VariableNames', {'Gapp' 'Gs' 'Rti'});
num_edges = numel(xform_list);
corresp = [[xform_list(:).i];[xform_list(:).j]]';
w = sqrt(sum([v(4:5,corresp(:,1))-v(4:5,corresp(:,2))].^2));
G = graph(corresp(:,1),corresp(:,2),w,'OmitSelfLoops');
[T,pred] = minspantree(G,'Type','forest'); 

s = pred(pred~=0);
t = find(pred~=0);

[ind,ind_st] = ismember(corresp,[s;t]','rows');
ind_st = nonzeros(ind_st);
invertedst = false(numel(ind_st),1);
Gmst = Gm(find(ind));

[corresp(:,2),corresp(:,1)] = deal(corresp(:,1),corresp(:,2));
[rind,rind_ts] = ismember(corresp,[s;t]','rows');
rind_ts = nonzeros(rind_ts);
invertedts = true(numel(rind_ts),1);
Gmts = Gm(find(rind));

edge_table = table([s(ind_st) s(rind_ts);t(ind_st) t(rind_ts)]', ...
                   [Gmst; Gmts], ...
                   [invertedst; invertedts], ...
                   'VariableNames', {'EndNodes' 'Gm' 'inverted'}); 

%edge_table = table([s(ind_st); t(ind_st)]', ...
%                   Gmst,  invertedst, ...
%                   'VariableNames', {'EndNodes' 'Gm' 'inverted'}); 
%
dG = digraph(edge_table,node_table);
%plot(dG,'NodeLabel',[1:num_nodes]);
%figure;plot(T)

rvertices = intersect(find(pred==0),pred);

%
%%y_ii = LAF.apply_rigid_xforms(model0.U(:,corresp.G_u), ...
%%                              model0.Rt_i(:,corresp.G_i));
%%y_jj = LAF.apply_rigid_xforms(y_ii,[model0.Rt_ij(:,corresp.G_ij)]);
%%
%%y_ii = LAF.rd_div(LAF.renormI(blkdiag(invH,invH,invH)*y_ii), ...
%%                  model0.cc,model0.q);
%%y_jj = LAF.rd_div(LAF.renormI(blkdiag(invH,invH,invH)*y_jj), ...
%%                  model0.cc,model0.q);
