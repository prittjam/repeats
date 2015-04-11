function [H,inl] = laf2_to_H(u,T)
u2 = [ reshape(u(1:9,:),3,[]); ...
       reshape(u(10:18,:),3,[]) ];
[H,inl0] = ransacH(u2,T,int32(4),0.99);
inl = all(reshape(inl0,3,[]));

if sum(inl) > 2
    if is_model_degen(u2(1:3,inl),H)
        H = [];
        inl = [];
    end
else
    H = [];
    inl = [];
end

function is_degen = is_model_degen(u,H)
%detH = l(3)-l(1)-l(2);
%is_degen = any((l'*v)/detH <= 0);
v = renormI(H*u);
is_degen = any(v(3,:)/v(3,1) <= 0);