function flag = are_colinear(u,T)
if nargin < 2
    flag = PT.are_colinear(u(4:6,:));
else
    flag = PT.are_colinear(u(4:6,:),T);
end