%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [Gs,Rti,Gmj] = composite_xforms(Tlist,Gm,inverted,...
                                         Rtij,X,num_vertices)
mtx_Rtij = Rt.params_to_mtx(Rtij);
inv_mtx_Rtij = Rt.params_to_mtx(Rt.invert(Rtij));
Gs =  nan(num_vertices,1);
Gmj = nan(num_vertices,1);
mtxRti = repmat(eye(3,3),1,1,num_vertices);

for k1 = 1:numel(Tlist)
    T = Tlist{k1};
    Gs(T(1,1)) = k1;
    for k2 = 1:size(T,1);
        gm = Gm(T(k2,1),T(k2,2));

        Gmj([T(k2,1) T(k2,2)]) = gm;
        if inverted(T(k2,1),T(k2,2))
            mtxRti(:,:,T(k2,2)) = ...
                inv_mtx_Rtij(:,:,gm)*mtxRti(:,:,T(k2,1));
        else
            mtxRti(:,:,T(k2,2)) = mtx_Rtij(:,:,gm)*mtxRti(:,:,T(k2,1));
        end
        Gs(T(k2,2)) = k1;
    end
end

Rti = Rt.mtx_to_params(mtxRti)';
