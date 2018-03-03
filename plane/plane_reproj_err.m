function err = plane_reproj_err(u,n)
if (size(u,1) == 3)
    u = [u;ones(1,size(u,2))];
end
err = sum(bsxfun(@times,u,n));