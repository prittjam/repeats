function draw_A(ax1,A,varargin)
M = 100;

if ~iscell(A)
    A = {A};
end

x = zeros(3,M*numel(A));

for k = 1:numel(A)
    A0 = A{k};
    t = linspace(0,2*pi,M);
    x(:,M*(k-1)+1:M*k) = renormI(A0*[cos(t);sin(t);ones(1,length(t))]);
end

mpdc = distinguishable_colors(numel(A));
hold(ax1,'on');
set(ax1,'ColorOrder',mpdc);    % <--- HERE
plot(reshape(x(1,:),M,[]),reshape(x(2,:),M,[]),varargin{:});
hold(ax1,'off');