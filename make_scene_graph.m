function [dG,rvertices] = make_scene_graph(v,xform_list)
corresp = [[xform_list(:).i];[xform_list(:).j]]';
%g = reshape(findgroups(corresp(:)),[],2);
w = sqrt(sum([v(4:5,corresp(:,1))-v(4:5,corresp(:,2))].^2));
%G = graph(g(:,1),g(:,2),w,'OmitSelfLoops');
G = graph([xform_list(:).i],[xform_list(:).j],w,'OmitSelfLoops');
[T,pred] = minspantree(G,'Type','forest');

s = pred(pred~=0);
t = find(pred~=0);

[ind,ind_st] = ismember(corresp,[s;t]','rows');
ind = find(ind);
[rind,rind_ts] = ismember(corresp,[t;s]','rows');
rind = find(rind);

K = numel(rind);
rxform_list = ...
    struct('i', mat2cell([xform_list(rind).i],1,ones(1,K)), ...
           'j', mat2cell([xform_list(rind).j],1,ones(1,K)), ...
           'Rt', mat2cell(Rt.invert([xform_list(rind).Rt]),4,ones(1,K)), ...
           'inverted', mat2cell(~[xform_list(rind).inverted],1, ...
                                ones(1,K)));

small_xform_list(nonzeros(ind_st)) = xform_list(ind);
small_xform_list(nonzeros(rind_ts)) = rxform_list;

node_table = table(repmat([0 0 0 1],size(v,2),1), ...
                   'VariableNames', {'Rti'});
edge_table = table([s;t]', ...
                   [small_xform_list(:).Rt]', ...
                   'VariableNames',{'EndNodes' 'Rtij'});
dG = digraph(edge_table,node_table);

rvertices = intersect(find(pred==0),pred(t));

%
%%y_ii = LAF.apply_rigid_xforms(model0.U(:,corresp.G_u), ...
%%                              model0.Rt_i(:,corresp.G_i));
%%y_jj = LAF.apply_rigid_xforms(y_ii,[model0.Rt_ij(:,corresp.G_ij)]);
%%
%%y_ii = LAF.rd_div(LAF.renormI(blkdiag(invH,invH,invH)*y_ii), ...
%%                  model0.cc,model0.q);
%%y_jj = LAF.rd_div(LAF.renormI(blkdiag(invH,invH,invH)*y_jj), ...
%%                  model0.cc,model0.q);
