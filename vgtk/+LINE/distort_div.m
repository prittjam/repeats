function ld = distort_div(l,q)
    if abs(q) > 0
        xc0 = - l(1,:) ./ l(3,:) ./ 2 ./ q;
        yc0 = - l(2,:) ./ l(3,:) ./ 2 ./ q;
        
        R = sqrt( (l(1,:).^2 + l(2,:).^2) ./...
                  (l(3,:).^2) ./ 4 ./ (q.^2) - 1 ./ q);

        v = PT.homogenize([xc0; yc0]);
        % v = A\v;
        % R = R ./ A(1,1);
        
        ld = [v(1:2,:); R];
    else
        ld = l;
    end
end