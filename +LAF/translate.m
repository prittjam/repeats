function v = translate(u,t)
z = zeros(1,size(t,2));
o = ones(1,size(t,2));
v = LAF.apply_rigid_xforms(u,[z;t;o]);
