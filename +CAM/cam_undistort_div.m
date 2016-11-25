function u = cam_undistort_div(u,ic,la)

%UDERAD - removes additive radial distortion from coordinates
%     function u = uderad(u, ic, la)
%     where ic is image centre and la is the parameter of the
%     radial distortion (see AWF: Simult. lin. est...)
%
%SEE ALSO: URAD, INORMU

%ic = (is+1) /2;
v = ones(size(u));
sc = 1/(2*sum(ic));
v(1:2,:) = bsxfun(@minus,diag([sc, sc])*u(1:2,:), ...
                  [sc*ic(1) sc*ic(2)]');
dv = 1 + la * (v(1,:).^2 + v(2,:).^2);
v(1,:)  = v(1,:) ./ dv; 
v(2,:)  = v(2,:) ./ dv; 
u(1:2,:) = bsxfun(@plus,diag([1/sc, 1/sc])*v(1:2,:), ...
                  [ic(1) ic( 2)]');
