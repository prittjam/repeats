function x2 = to_homogeneous(x)
    x2 = [x;ones(1,size(x,2))];
