function u = cam_dist_div(u,ic,la)
%URAD - adds additive radial distortion to coordinates
%     function u = urad(u, ic, la)
%     where ic is image centre and la is the parameter of the
%     radial distortion (see AWF: Simult. lin. est...)
%
%SEE ALSO: UDERAD, INORMU

%ic = (is+1) /2;

if abs(la) > eps
    A = inormu(ic);
    v = A * u;
    r2= (v(1,:).^2 + v(2,:).^2);
    r = sqrt(r2);
    d = (1 - sqrt(1 - 4*la*r2)) ./ (2*la*r);
    dv = d./r; 
    v(1,:)  = v(1,:) .* dv; 
    v(2,:)  = v(2,:) .* dv; 
    u = inv(A) * v;
end