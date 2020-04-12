function res = belongs(l, x)
    if size(x,1)==2
        x = PT.homogenize(x);
    else
        x = PT.renormI(x);
    end
    l = LINE.inhomogenize(l);
    res = (abs(dot(l,x)) < 1e-15);