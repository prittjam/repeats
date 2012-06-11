function u = cam_udist_div(u,ic,la)

%UDERAD - removes additive radial distortion from coordinates
%     function u = uderad(u, ic, la)
%     where ic is image centre and la is the parameter of the
%     radial distortion (see AWF: Simult. lin. est...)
%
%SEE ALSO: URAD, INORMU

%ic = (is+1) /2;
A = inormu(ic);
v = A * u;
dv = 1 + la * (v(1,:).^2 + v(2,:).^2);
v(1,:)  = v(1,:) ./ dv; 
v(2,:)  = v(2,:) ./ dv; 
u = inv(A) * v;