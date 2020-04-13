function circ = normalize(circ, A)
    c = A * PT.homogenize(circ(1:2,:));
    p = A * PT.homogenize(circ(4:5,:));
    circ(1:2,:) = c(1:2,:);
    circ(3,:) = A(1,1) * circ(3,:);
    circ(4:5,:) = p(1:2,:);
end
