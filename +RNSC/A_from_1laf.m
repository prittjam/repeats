function [A,inl] = A_from_1laf(u,T)
inl = [];
A = [];
for k = 1:size(u,2)
    A0 = HG.A_from_1laf(u(:,k));
    err = LAF.sampson_err(u,A0);
    inl0 = all(err < T);
    if sum(inl0) > sum(inl)
        inl = inl0;
        A = A0;
    end
end