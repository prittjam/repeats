function v = util_make_homogeneous(u)
v = [u;ones(1,size(u,2))];