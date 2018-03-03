function [] = vp_est_np_lsqnonlin(vp,u)
N = size(u,2);

H0 = cfg.model_args;

extract = @(vp,u) [vp(:);atan2(u(3:4,:)-u(1:2,:))'];

h = lsqnonlin(wrap_err, extract(vp,u), [], [], ...
              optimset('Display', 'Off', ...
                       'Diagnostics', 'Off', ...
                       'MaxIter', 3), ...
              u);

H = { reshape([h 1],3,3) };

function d = vp_pt_err(x)
theta = x(3:end)';
N = numel(theta);

vpl = repmat(x(1:2),1,N);

n = [ cos(theta); ...
      sin(theta); ...
      -a.*vpl(1,:)-b.*vpl(2,:); ];

u2 = [ u(1:2,:); ...
       ones(1,N); ...
       u(3:4,:); ...
       ones(1,N) ];

n2 = repmat(n,1,2);
d = reshape(n2.*u2,1,[]);