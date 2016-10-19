function T = rptsim_make_template_xforms(num_rows,num_cols,w2,h2,dx,dy,do_rot)
m = num_rows*num_cols;
dphi  = 2*pi/m;
phi = 0;
for r = 1:num_rows
    for c = 1:num_cols
        cc = cos(phi);
        ss = sin(phi);
        if do_rot
            R1 = [ cc -ss  0; ...
                   ss  cc  0; ...
                   0   0   1];
            phi = phi+dphi;
        else
            R1 = eye(3);
        end
        R1(1:2,3) = [(c-1)*dx+(c-1)*w2+dx/2+w2/2 (r-1)*dy+(r-1)*h2+dy/2+h2/2]';
        T{r,c} = R1;
    end
end