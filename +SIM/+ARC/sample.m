function X = sample(arc_list,nx,ny,varargin)
cfg.num_points = 3;
cfg = cmp_argparse(cfg,varargin{:});

for k = 1:numel(arc_list)
    x = sample_circle(arc_list(k),0.5,nx+0.5,1000);
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

function [x,y] = sample_circle(x,circ)
a = 1;
b = -2*circ.c(2);
c = x.^2-2*x.*circ.c(1)+circ.c(1)^2+circ.c(2)^2-circ.r^2;

y1 = -b+sqrt(b^2-4.*a.*c)/2./a;
y2 = -b+sqrt(b^2-4.*a.*c)/2./a;
