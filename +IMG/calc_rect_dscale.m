function [img,si_fn,xurect] = calc_rect_dscale(dims,l,varargin)
cfg.ruxform = maketform('affine',eye(3));
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

nx = dims(2);
ny = dims(1);
l = l/l(3);

rect = [0.5    0.5; ...
        nx-0.5 ny-0.5];

cartesian = make_change_of_scale_constraints();
si_fn = cartesian.si10_fn;

xurect = tformfwd(cfg.ruxform,rect);

xmin = floor(min(xurect(:,1)));
xmax = ceil(max(xurect(:,1)));
ymin = floor(min(xurect(:,2)));
ymax = ceil(max(xurect(:,2)));

[u,v] = meshgrid(xmin:xmax,ymin:ymax);

xu = [u(:)'-0.5; ...
     v(:)'-0.5; ...
     ones(1,numel(u))];

sc = si_fn(l(1),l(2),1,xu(1,:),xu(2,:));

udny = ymax-ymin+1;
udnx = xmax-xmin+1;

img = reshape(sc,udny,udnx);