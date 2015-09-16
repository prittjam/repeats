function position = which_side(line,pts)
% line is a 2x2 matrix
% rows equal to coordinates, columns to points
%  1 -> on the left side
% -1 -> on the ride side
%  0 -> on the line
A = line(:,1); 
B = line(:,2);
position = sign((B(1)-A(1))*(pts(2,:)-A(2))-(B(2)-A(2))*(pts(1,:)-A(1)));