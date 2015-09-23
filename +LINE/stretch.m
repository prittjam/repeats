function line2 = stretch(line, mult)
% line is a 2x2 matrix
% rows equal to coordinates, columns to points
differ = line(:,1) - line(:,2);
line2 = line;
line2(:,1) = line(:,1) + differ*mult;
line2(:,2) = line(:,2) - differ*mult;