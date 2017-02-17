function v = translate(u,t)
z = zeros(1,size(t,2));
Rt = struct('theta', mat2cell(z,1,ones(1,numel(z))), ...
            't', mat2cell(t,2,ones(1,size(t,2))));
v = LAF.apply_rigid_xforms(u,Rt);
