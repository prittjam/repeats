function M = params_to_mtx(Rt)
num_xforms = size(Rt,2);

c = cos(Rt(1,:));
s = sin(Rt(1,:));
z = zeros(1,num_xforms);

M = reshape([Rt(4,:).*c ; Rt(4,:).*s ; z; ...
             -s; c; z; ...
             Rt(2,:); Rt(3,:); ones(1,num_xforms)],3,3,num_xforms);

%M =  [ Rt(4).*c -s Rt(2); ...
%       Rt(4).*s  c Rt(3); ...
%       0 0 1];
%
