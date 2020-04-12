function [p, n] = get_midpoint(circ, s1, s2)
    if size(s1,1) == 2
        s1 = PT.homogenize(s1);
        s2 = PT.homogenize(s2);
    end
    chords = PT.renormI(cross(s1, s2));
    n = chords(1:2,:);
    n = n ./ vecnorm(n, 2, 1);
    n = n .* sign(dot(n, s1(1:2,:) - circ(1:2,:)));
    p = circ(1:2,:) + circ(3,:) .* n;
end