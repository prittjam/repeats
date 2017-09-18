function vertex_data = composite_xforms(Tlist,Gm,inverted,...
                                        Rtij,X,num_vertices)
mtx_Rtij = Rt.params_to_mtx(Rtij);
inv_mtx_Rtij = Rt.params_to_mtx(Rt.invert(Rtij));

vertex_data = struct('Rti', repmat([0 0 0 1],num_vertices,1), ...
                     'Gs', nan(num_vertices,1));
Rti = repmat(eye(3,3),1,1,num_vertices);

for k1 = 1:numel(Tlist)
    T = Tlist{k1};
    vertex_data.Gs(T(1,1)) = k1;
    for k2 = 1:size(T,1);
        gm = Gm(T(k2,1),T(k2,2));
        if inverted(T(k2,1),T(k2,2))
            Rti(:,:,T(k2,2)) = inv_mtx_Rtij(:,:,gm)*Rti(:,:,T(k2,1));
        else
            Rti(:,:,T(k2,2)) = mtx_Rtij(:,:,gm)*Rti(:,:,T(k2,1));
        end
        vertex_data.Gs(T(k2,2)) = k1;
    end
end

vertex_data.Rti = Rt.mtx_to_params(Rti)';
