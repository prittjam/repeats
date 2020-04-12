function ld = distort_div(l,q,varargin)
    if abs(q) > 0
        A = CAM.make_norm_xform(varargin{:});
        l0 = A' \ l;

        xc0 = - l0(1,:) ./ l0(3,:) ./ 2 ./ q;
        yc0 = - l0(2,:) ./ l0(3,:) ./ 2 ./ q;
        
        R = sqrt( (l0(1,:).^2 + l0(2,:).^2) ./...
                  (l0(3,:).^2) ./ 4 ./ (q.^2) - 1 ./ q);

        v = PT.homogenize([xc0; yc0]);
        v = A\v;
        R = R ./ A(1,1);
        
        ld = [v(1:2,:); R];
    else
        ld = l;
    end
end