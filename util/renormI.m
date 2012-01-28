function [Y] = renormI(X)
    Y = X./repmat(X(end,:),[size(X,1) 1]);