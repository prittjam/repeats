function Rt = p2_to_Rt(v)
u1c = mean(reshape(u(abc,nonzeros(vis(pred(j),col_idx))), ...
                             2,[]),2);
u2c = mean(reshape(u(abc,nonzeros(vis(j,col_idx))), ...
                     2,[]),2);

a = bsxfun(@minus,reshape(u(abc,nonzeros(vis(pred(j),col_idx))), ...
                          2,[]),u1c);
b = bsxfun(@minus,reshape(u(abc,nonzeros(vis(j,col_idx))),...
                          2,[]),u2c);

[U,~,V] = svd(a*b');
R = V*U';
theta(i) = theta(i)+atan2(R(2,1),R(1,1));
t(1:2,i) = t(1:2,i)+u2c-R*u1c;