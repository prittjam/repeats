function w = join_to_lafs(u,segments)
num_lafs = size(u,2);
v = LAF.p3x3_to_poly(u);
for k = 1:size(v,2)
    BW = poly2mask(v(1:2:end,k),v(2:2:end,k), ...
                   size(segments,1),size(segments,2));
    w{k} = setdiff(unique(BW.*segments),0);
end