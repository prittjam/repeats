function z = vl_orientation(u,vl)
HH0 = HG.vl_to_Hinf(vl);
z = vl'*reshape(u,3,[]);