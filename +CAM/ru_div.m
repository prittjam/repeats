function w = ru_div(u,cc,la)
%UDERAD - removes additive radial distortion from coordinates
%     function u = uderad(u, cc, la)
%     where cc is image centre and la is the parameter of the
%     radial distortion (see AWF: Simult. lin. est...)
%
%SEE ALSO: URAD, INORMU
if (size(u,1) == 2)
    u = [u;ones(1,size(u,2))];
end

sc = sum(2*cc);
A = [1/sc   0  -cc(1)/sc; ...
     0   1/sc  -cc(2)/sc; ...
     0     0       1];

v = A*u;

dv = 1+la*(v(1,:).^2+v(2,:).^2);
v(1,:)  = v(1,:)./dv; 
v(2,:)  = v(2,:)./dv; 

w = inv(A)*v;
w = w(1:2,:);
