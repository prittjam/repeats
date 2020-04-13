function res = belongs(circ, x)
    cx = circ(1,:);
    cy = circ(2,:);
    r = circ(3,:);
    res = abs( (((x(1,:) - cx) ./ r).^2 +...
                ((x(2,:) - cy) ./ r).^2) - 1 ) < 1e-12;