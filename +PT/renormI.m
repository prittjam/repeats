function Y = renormI(X)
    Y = bsxfun(@rdivide,X,X(end,:));
