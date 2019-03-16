%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [rtree,X,Rtij,Tlist,d2] = make_scene_graph(x,cspond,model0,Rtij0,vqT)
Hinf = model0.H;

v = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,model0.cc,model0.q));
num_edges = size(cspond,2);

w = sqrt(sum([v(4:5,cspond(1,:))-v(4:5,cspond(2,:))].^2));
edge_table = table([cspond(1,:);cspond(2,:)]', -w', [1:num_edges]', ...
                   'VariableNames',{'EndNodes','Weight','Ind'});
G = graph(edge_table,'OmitSelfLoops');

[T,pred] = minspantree(G,'Type','forest'); 

s = pred(pred~=0);
t = find(pred~=0);

Rtij = zeros(3,3,numedges(T));
[ind,ind_st] = ...
    ismember(cspond',[s;t]','rows');
Rtij(:,:,nonzeros(ind_st)) = Rtij0(:,:,find(ind));

[cspond(2,:),cspond(1,:)] = deal(cspond(1,:),cspond(2,:));
[rind,rind_ts] = ismember(cspond',[s;t]','rows');

Rtij(:,:,nonzeros(rind_ts)) = multinv(Rtij0(:,:,find(rind)));

edge_table = table([s;t]', [1:numedges(T)]', ...
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
cspond = transpose(rtree.Edges.EndNodes);

xp = PT.renormI(blkdiag(Hinf,Hinf,Hinf)*PT.ru_div(x,model0.cc,model0.q));

ut_j = PT.rd_div(PT.renormI( ...
    PT.mtimesx(multiprod(Hinv,Rtij),xp(:,cspond(1,:)))),...
                  model0.cc,model0.q);
invRtij = multinv(Rtij);

ut_i =  PT.rd_div(PT.renormI( ...
    PT.mtimesx(multiprod(Hinv,invRtij),xp(:,cspond(2,:)))), ...
                  model0.cc,model0.q);
d2 = sum([ut_j-x(:,cspond(2,:)); ...
          ut_i-x(:,cspond(1,:))].^2);

inl = find(double(d2 < vqT));

assert(numel(inl)==size(cspond,2), ...
       'Error did not increase');