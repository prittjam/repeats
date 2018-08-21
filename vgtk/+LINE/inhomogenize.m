function l = inhomogenize(l0)
l = l0./sqrt(sum(l0(1:2,:).^2));
