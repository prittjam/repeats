function [Rt,ii,jj,is_reflected] = laf2xNxN_to_RtxNxN(u,varargin)
cfg.do_reflection = false;
cfg.motion_model = 'laf2xN_to_RtxN';
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

N = size(u,2);
[ii,jj] = itril([N N],-1);
Rt = feval(cfg.motion_model,[u(:,ii);u(:,jj)]);

t = [Rt(:).t];
theta = [Rt(:).theta];

is_reflected = false(1,numel(theta));

if cfg.do_reflection
    is_reflected = t(1,:) < 0;
    theta(is_reflected) = -1*theta(is_reflected);
    t(:,is_reflected) = PT.apply_rigid_xforms(-1*t(:,is_reflected), ...
                                              theta(is_reflected), ...
                                              zeros(2,sum(is_reflected)));
    [jj(is_reflected),ii(is_reflected)] = deal(ii(is_reflected), ...
                                               jj(is_reflected));
end
K = numel(Rt);
Rt = struct('theta',mat2cell(theta,1,ones(1,K)), ...
            't', mat2cell(t,2,ones(1,K)));
