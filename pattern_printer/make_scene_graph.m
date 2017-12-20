function [rtree,X,Rtij,Tlist] = make_scene_graph(x,corresp,model0,Rtij0,varargin)
cfg = struct('vqT',21.026);
cfg = cmp_argparse(cfg,varargin{:});

Hinf = model0.Hinf;

v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*LAF.ru_div(x,model0.cc,model0.q));
%xp2 = LAF.apply_rigid_xforms(v(:,corresp(1,:)),Rtij0);
%dist = sum((xp2-v(:,corresp(2,:))).^2);
%
num_edges = size(corresp,2);

w = sqrt(sum([v(4:5,corresp(1,:))-v(4:5,corresp(2,:))].^2));
edge_table = table([corresp(1,:);corresp(2,:)]', -w', [1:num_edges]', ...
                   'VariableNames',{'EndNodes','Weight','Ind'});
G = graph(edge_table,'OmitSelfLoops');

[T,pred] = minspantree(G,'Type','forest'); 

s = pred(pred~=0);t = find(pred~=0);
Rtij = zeros(4,numedges(T));
[ind,ind_st] = ...
    ismember(corresp',[s;t]','rows');
Rtij(:,nonzeros(ind_st)) = Rtij0(:,find(ind));

[corresp(2,:),corresp(1,:)] = deal(corresp(1,:),corresp(2,:));
[rind,rind_ts] = ...
    ismember(corresp',[s;t]','rows');
Rtij(:,nonzeros(rind_ts)) = Rt.invert(Rtij0(:,find(rind)));
edge_table = table([s;t]', ...
                   [1:numedges(T)]', ...
                   'VariableNames', {'EndNodes' 'Ind'}); 
rtree = digraph(edge_table);
rvertices = intersect(find(pred==0),pred);
Rtij = Rtij(:,rtree.Edges.Ind);
X = v(:,rvertices);

for k1 = 1:numel(rvertices)
    Tlist{k1} = bfsearch(rtree,rvertices(k1),{'edgetonew'}); 
end

check_err(x,rtree,Rtij,model0,cfg.vqT);

function is_good = check_err(x,rtree,Rtij,model0,vqT)
Hinf = model0.Hinf;
Hinv = inv(Hinf);
corresp = transpose(rtree.Edges.EndNodes);
ind = rtree.Edges.Ind;

xp = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*LAF.ru_div(x,model0.cc,model0.q));

ut_j = ...
    LAF.rd_div(LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                           LAF.apply_rigid_xforms(xp(:,corresp(1,:)),Rtij)), ...
               model0.cc,model0.q);
invrt = Rt.invert(Rtij);
ut_i = ...
    LAF.rd_div(LAF.renormI(blkdiag(Hinv,Hinv,Hinv)* ...
                           LAF.apply_rigid_xforms(xp(:,corresp(2,:)),invrt)), ...
                           model0.cc,model0.q);

d2 = sum([ut_j-x(:,corresp(2,:)); ...
          ut_i-x(:,corresp(1,:))].^2);
inl = find(double(d2 < vqT));

assert(numel(inl)==size(corresp,2), ...
       'Error did not increase');
