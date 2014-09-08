function [K,Q,D,W,l,qf] = draw(ax1,CC,varargin)
%
%  [K,Q,D,W,l,qf] = ellipse(A)
%
%   Draws the ellipse 
%      x' * K * x = 1
%    corresponding to the positive definite symmetric 2 by 2 matrix 
%    where K = A if A is symmetric; otherwise K = A' * A
%
%  K - symmetric positive definite matrix used
%  Q - orthogonal eigenvectors or principal axes of ellipse
%  D - diagonal matrix with eigenvalues, so K = Q * D * Q'
%  l = 1/sqrt(diag(D)) - lengths of semi-axes of ellipse
%  W = Q*D^(-1/2) - linear transformation mapping unit circle to ellipse
%  qf - string giving quadratic form x'*K*x
%
%  See also ELLIPSOID
%
if ~iscell(CC)
    CC = {CC};
end

colors = varycolor(numel(CC));

for k = 1:numel(CC)
    C = CC{k};
    [A,m] = ELL.get_A_from_C(C);
    t = linspace(0,2*pi,100);
    x = renormI(A*[cos(t);sin(t);ones(1,length(t))]);
    hold all;
    plot(ax1,m(1),m(2),'Color',colors(k,:),varargin{:});
    plot(ax1,x(1,:),x(2,:),'Color',colors(k,:),varargin{:});
    hold off;
end