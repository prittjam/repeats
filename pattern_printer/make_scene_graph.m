%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [rtree,X,Rtij,Tlist,d2] = make_scene_graph(x,corresp,model0,Rtij0,vqT)
Hinf = model0.H;

v = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,model0.cc,model0.q));
num_edges = size(corresp,2);

w = sqrt(sum([v(4:5,corresp(1,:))-v(4:5,corresp(2,:))].^2));
edge_table = table([corresp(1,:);corresp(2,:)]', -w', [1:num_edges]', ...
                   'VariableNames',{'EndNodes','Weight','Ind'});
G = graph(edge_table,'OmitSelfLoops');

[T,pred] = minspantree(G,'Type','forest'); 

s = pred(pred~=0);
t = find(pred~=0);

Rtij = zeros(3,3,numedges(T));
[ind,ind_st] = ...
    ismember(corresp',[s;t]','rows');
Rtij(:,:,nonzeros(ind_st)) = Rtij0(:,:,find(ind));

[corresp(2,:),corresp(1,:)] = deal(corresp(1,:),corresp(2,:));
[rind,rind_ts] = ...
    ismember(corresp',[s;t]','rows');

Rtij(:,:,nonzeros(rind_ts)) = multinv(Rtij0(:,:,find(rind)));

edge_table = table([s;t]', ...
                   [1:numedges(T)]', ...
                   'VariableNames', {'EndNodes' 'Ind'}); 
rtree = digraph(edge_table);
rvertices = intersect(find(pred==0),pred);
Rtij = Rtij(:,:,rtree.Edges.Ind);
X = v(:,rvertices);

for k1 = 1:numel(rvertices)
    Tlist{k1} = bfsearch(rtree,rvertices(k1),{'edgetonew'}); 
end

d2 = check_err(x,rtree,Rtij,model0,vqT);

function d2 = check_err(x,rtree,Rtij,model0,vqT)
Hinf = model0.H;
Hinv = inv(Hinf);
corresp = transpose(rtree.Edges.EndNodes);
ind = rtree.Edges.Ind;

xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,model0.cc,model0.q));

ut_j =  PT.rd_div(PT.renormI( ...
    PT.apply_xforms(xp(:,corresp(1,:)),mtimesx(Hinv,Rtij))),...
                  model0.cc,model0.q);
invRtij = multinv(Rtij);
ut_i =  PT.rd_div(PT.renormI( ...
    PT.apply_xforms(xp(:,corresp(2,:)),mtimesx(Hinv,invRtij))), ...
                  model0.cc,model0.q);
d2 = sum([ut_j-x(:,corresp(2,:)); ...
          ut_i-x(:,corresp(1,:))].^2);

inl = find(double(d2 < vqT));

assert(numel(inl)==size(corresp,2), ...
       'Error did not increase');