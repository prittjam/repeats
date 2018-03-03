function x2 = homogenize(x)
    x2 = [x;ones(1,size(x,2))];
