function circ = normalize(circ, varargin)
    A = CAM.make_norm_xform(varargin{:});
    c = A * PT.homogenize(circ(1:2,:));
    p = A * PT.homogenize(circ(4:5,:));
    circ(1:2,:) = c(1:2,:);
    circ(3,:) = A(1,1) * circ(3,:);
    circ(4:5,:) = p(1:2,:);
end
