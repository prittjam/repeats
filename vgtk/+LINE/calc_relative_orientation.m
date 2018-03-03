function [min_dtheta,IJ] = ...
    calc_relative_orientation(l)
n = size(l,2);
IJ = VChooseK(1:n,2);
theta = atan(l(2,:)./l(1,:));
for k = 1:numel(IJ)
    dtheta = abs(theta(IJ(k,1))-theta(IJ(k,2)));
    min_dtheta(k) = min(dtheta,pi-dtheta);
end
