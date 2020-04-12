%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw_circle(ax1,c,varargin)
cfg.xintvl = [];
cfg.yintvl = [];
cfg.lim = false;

[cfg,leftover] = cmp_argparse(cfg,varargin{:});
    
m = 100;
t = linspace(0,2*pi,m);
A = eye(3);
x = zeros(3,m*size(c,2));

for k = 1:size(c,2)
    A(1,1) = c(3,k);
    A(2,2) = c(3,k);
    A(1:2,3) = c(1:2,k);
    x(:,m*(k-1)+1:m*k) = A*[cos(t);sin(t);ones(1,length(t))];
end

good1 = true(1,size(x,2));
good2 = good1;

if ~isempty(cfg.xintvl)
    good1 = (min([cfg.xintvl(1) cfg.xintvl(2)]) < x(1,:)) & ...
            (x(1,:) < max([cfg.xintvl(1) cfg.xintvl(2)]));
end

if ~isempty(cfg.yintvl)
    good2 = (min([cfg.yintvl(1) cfg.yintvl(2)]) < x(2,:)) & ...
            (x(2,:) < max([cfg.yintvl(1) cfg.yintvl(2)]));
end

x = x(:,good1 & good2);

lims = [xlim;ylim];
hold on;
plot(ax1,x(1,:),x(2,:),leftover{:});

if cfg.lim
    x = [x(1:2,:) lims];
    xlim([min(x(1,:)) max(x(1,:))]);
    ylim([min(x(2,:)) max(x(2,:))]);
end
hold off;