function [rtree,x] = composite_xforms(rtree,rvertices,Rtij,X,Gs)
mtx_Rtij = zeros(3,3,size(Rtij,2));

for k = 1:size(Rtij,2)
    mtx_Rtij(:,:,k) = Rt.params_to_mtx(Rtij(:,k));
end

for k1 = 1:numel(rvertices)
    T = bfsearch(rtree,rvertices(k1),{'edgetonew'}); 
    x = X(:,k1);
    rtree.Nodes.Gs(T(1,1)) = k1;
    for k2 = 1:size(T,1);
        [~,Locb] = ismember(T(k2,:),rtree.Edges.EndNodes,'Rows');
        Gm = rtree.Edges.Gm(Locb);
        if rtree.Edges.inverted(Locb)
            mtxij = inv(mtx_Rtij(:,:,Gm));
        else
            mtxij = mtx_Rtij(:,:,Gm);
        end
        mtx = mtxij*Rt.params_to_mtx(rtree.Nodes.Rti(T(k2,1),:));
        rtree.Nodes.Gs(T(k2,2)) = k1;
        rtree.Nodes.Rti(T(k2,2),:) = Rt.mtx_to_params(mtx);
        x = blkdiag(mtx,mtx,mtx)*X(:,k1);
    end
end
