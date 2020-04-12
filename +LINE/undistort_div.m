function L = undistort_div(l,q)
    % l -- 3xN [cx...; cy...; R]
    % or
    % l -- 4xN [px...; py...; nx...; ny...]
    if size(l,1)==3
        assert(nargin==4)
        assert(size(l,2)==size(p,2))
        if size(p,1)==3
            p = PT.renormI(p);
        end
        n = (p(1:2,:) - l(1:2,:)) ./ l(3,:);
        assert(all(abs(vecnorm(n,2,1)-1) < 1e-13))
        l = [p(1:2,:); n];
    end

    % A = CAM.make_norm_xform(varargin{:});
    % l0 = A * PT.homogenize(l(1:2,:));
    l0 = l;
    l = [l0(1:2,:); l(3:4,:)];

    px = l(1,:);
    py = l(2,:);
    nx = l(3,:);
    ny = l(4,:);

    Lx = nx + q * (nx .* px.^2 - nx .* py.^2 +...
                  2 * ny .* px .* py);
    Ly = ny + q * (ny .* py.^2 - ny .* px.^2 +...
                  2 * nx .* px .* py);
    Lz = - nx .* px - ny .* py;
    L = [Lx; Ly; Lz];
end