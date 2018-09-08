%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function sx = make_random(num_lafs)
x1 = repmat([0 1]',1,num_lafs);
theta = pi/3*rand(1,num_lafs)+pi/3;
s = sin(theta);
c = cos(theta);
sc = 3*rand(1,num_lafs)+0.1;
x3 = bsxfun(@times,sc,[c.*x1(1,:)-s.*x1(2,:);s.*x1(1,:)+c.*x1(2,:)]);
xc = [x1;ones(1,num_lafs);zeros(2,num_lafs);ones(1,num_lafs);x3; ...
      ones(1,num_lafs)];
xc = LAF.apply_rigid_xforms(xc,[2*pi*rand(1,num_lafs);zeros(2,num_lafs);ones(1,num_lafs)]);

tsc = 0.001*rand(1,num_lafs)+0.001;
sc = LAF.calc_scale(xc);
s = sqrt(tsc./sc);
sx = zeros(9,num_lafs);
for k = 1:numel(s)

    S = [s(k) 0    0; ...
         0    s(k) 0; ...
         0     0   1];
    sx(:,k) = blkdiag(S,S,S)*xc(:,k);
end
