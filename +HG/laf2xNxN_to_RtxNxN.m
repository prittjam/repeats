function [Rt,ii,jj,is_inverted] = laf2xNxN_to_RtxNxN(u,varargin)
cfg.do_inversion = false;
cfg.is_reflected = [];
cfg.motion_model = 'laf2xN_to_RtxN';

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

N = size(u,2);
[ii,jj] = itril([N N],-1);

Rt = feval(cfg.motion_model,[u(:,ii);u(:,jj)]);
is_inverted = false(1,N);

if cfg.do_inversion
    is_inverted = Rt(2,:) < 0;
    Rt(1,is_inverted) = -1*Rt(1,is_inverted);
    Rt(2:3,is_inverted) = PT.apply_rigid_xforms(-1*Rt(2:3,is_inverted), ...
                                                Rt(1,is_inverted), ...
                                                zeros(2,sum(is_inverted)));
    [jj(is_inverted),ii(is_inverted)] = deal(ii(is_inverted), ...
                                             jj(is_inverted));
end
