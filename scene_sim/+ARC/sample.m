%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function X = sample(arc_list,nx,ny,varargin)
cfg.num_points = 3;
cfg = cmp_argparse(cfg,varargin{:});
for k = 1:numel(arc_list)
    x = sample_circle(linspace(0.5,0.5+nx,1000),arc_list(k));
    border = [0.5 0.5; ...
              nx  0.5; ...
              nx  ny; ...
              0.5 ny; ...
              0.5 0.5];
    in = find(inpolygon(x(1,:),x(2,:),border(:,1)',border(:,2)'));
    ind = randperm(numel(in),cfg.num_points);
    X{k} = [x(:,in(ind)); ...
            ones(1,numel(ind))];
end

function z = sample_circle(x,circ)
inl = abs(x-circ.c(1)) <= circ.r;
x = x(inl);
a = 1;
b = -2*circ.c(2);
c = x.^2-2*x.*circ.c(1)+circ.c(1)^2+circ.c(2)^2-circ.r^2;
y = [-b+sqrt(b^2-4.*a.*c) -b-sqrt(b^2-4.*a.*c)]./2./a;
z = [x x; y];
