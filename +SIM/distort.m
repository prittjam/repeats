function pts = distort(pts,cam,lambda)
u = [pts(:).u];
N = size(u,2);
if (lambda ~= 0)
    ud = CAM.rd_div(u,cam.cc,lambda);
else
    ud = u;
end

tmp = mat2cell(ud,3,ones(1,N));
[pts(:).ud] = tmp{:};
