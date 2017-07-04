function arc_list = make_arcs(nx,ny,cc,q_gt,varargin)
cfg.num_arcs = 3;
cfg = cmp_argparse(cfg,varargin{:});

num_pts = 2*cfg.num_arcs;
pts = [ceil([nx;ny].*rand(2,num_pts)); ...
       ones(1,num_pts)];
o = zeros(2,cfg.num_arcs);
r = zeros(1,cfg.num_arcs);

for k = 1:cfg.num_arcs
    x = [pts(1:2,2*(k-1)+1) pts(1:2,2*(k-1)+2)];
    [o(:,k),r(k)] = pt1x2qcc_to_circle(x,cc,q_gt);
end

arc = struct('c',mat2cell(o,2,ones(1,cfg.num_arcs)), ...
             'r',mat2cell(r,1,ones(1,cfg.num_arcs)));
