function Rt = mtx_to_params(M)
%Rt = zeros(1,4);
%Rt(1) = atan2(-M(4),M(5));
%Rt(2:3) = M(7:8);
%%Rt(4) = det(M);
%Rt(4) = M(1)*M(5)-M(2)*M(4);


Rt = zeros(4,size(M,3));
Rt(1,:) = atan2(-M(1,2,:),M(2,2,:));
Rt(2:3,:) = M([1 2],3,:);
%Rt(4) = det(M);
Rt(4,:) = M(1,1,:).*M(2,2,:)-M(2,1,:).*M(1,2,:);
