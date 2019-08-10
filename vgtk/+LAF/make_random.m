%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function sx = make_random(num_lafs,varargin)
cfg = struct('Orientation','CounterClockwise');
cfg = cmp_argparse(cfg,varargin{:});

x1 = repmat([0 1 1]',1,num_lafs);

theta = -(pi/3)+rand(1,num_lafs)*2*pi/3;
M = Rt.params_to_mtx([theta; ...
                    zeros(2,num_lafs); ...
                    ones(1,num_lafs)]);

sc = reshape(3*rand(1,num_lafs)+0.1,1,1,[]);
M(1:2,1:2,:) = M(1:2,1:2,:).*reshape(sc,1,1,[]);

x3 = PT.mtimesx(M,[ones(1,num_lafs); ...
                   zeros(1,num_lafs); ...
                   ones(1,num_lafs)]);

xc = [x1;zeros(2,num_lafs); ones(1,num_lafs); x3];

if strcmpi(cfg.Orientation,'Clockwise')
    xc = PT.reverse_orientation(xc);
end

T = Rt.params_to_mtx([2*pi*rand(1,num_lafs); ...
                    zeros(2,num_lafs); ...
                    ones(1,num_lafs)]);
xc = PT.mtimesx(T,xc);
tsc = 0.001*rand(1,num_lafs)+0.001;
sc = abs(PT.calc_scale(xc));
s = sqrt(tsc./sc);
sx = zeros(9,num_lafs);
for k = 1:numel(s)
    S = [2*s(k) 0    0; ...
         0    2*s(k) 0; ...
         0     0   1];
    sx(:,k) = blkdiag(S,S,S)*xc(:,k);
end