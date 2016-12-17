function u = rd_div(u,ic,la)
%URAD - adds additive radial distortion to coordinates
%     function u = urad(u, ic, la)
%     where ic is image centre and la is the parameter of the
%     radial distortion (see AWF: Simult. lin. est...)
%
%SEE ALSO: UDERAD, INORMU

%ic = (is+1) /2;

v = ones(size(u));

if abs(la) > eps
    sc = 1/(2*sum(ic));
    v(1:2,:) = bsxfun(@minus,diag([sc, sc])*u(1:2,:), ...
                      [sc*ic(1) sc*ic(2)]');
    r2 = (v(1,:).^2 + v(2,:).^2);
    r = sqrt(r2);
    d = (1 - sqrt(1 - 4*la*r2)) ./ (2*la*r);
    dv = d./r; 
    v(1,:)  = v(1,:) .* dv; 
    v(2,:)  = v(2,:) .* dv; 
    u(1:2,:) = bsxfun(@plus,diag([1/sc, 1/sc])*v(1:2,:), ...
                      [ic(1) ic( 2)]');
end
