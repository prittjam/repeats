function H = AntoRH (Ns, Ds)

% function H = AntoRH (Ns, Ds)
%
% computes homography H from N > 2 ellipse-to-ellipse correspondences
% Ns is 3x3xN matrix, each Ns(:,:,i) representing affine transformations
%   normalizing ellipses in the first image to unit circles
% Ds is 3x3xN matrix, each Ds(:,:,i) representing affine transformations
%   de-normalizing unit circles to ellipses in the second image
%
% For more details see  Chum, Matas ICPR 2012:.
% Homography Estimation from Correspondences of Local Elliptical Features
%
% (C) Ondra Chum 2012

do_norm = 1;

len = size(Ns, 3);
u = zeros(6,len);

for i = 1:len
  iN = inv(Ns(:,:,i));
  u(:,i) = [iN(:,3); Ds(:,3,i)];
end

if do_norm
  T1 = normu(u(1:2,:));
  iT1 = inv(T1);
  T2 = normu(u(4:5,:));

  for i = 1:len
    Ns(:,:,i) = Ns(:,:,i) * iT1;
    Ds(:,:,i) = T2 * Ds(:,:,i);
  end

  u(1:3,:) = T1 * u(1:3,:);
  u(4:6,:) = T1 * u(4:6,:);
end

Z = [];

for i = 1:len
  Zi = [getZ(u(:,i)), zeros(7,3*(i-1)), nd(Ds(:,:,i),Ns(:,:,i)), zeros(7,3*(len-i))];
  Z = [Z; Zi];
end

[u, d, v] = svd(Z);
H = reshape(v(1:9,end), 3, 3)';

%[V,D] = eig(Z'*Z);
%[~,p] = min(diag(D));
%H = reshape(V(1:9,p), 3, 3)';


if do_norm
  H = inv(T2) * H * T1;
end

function Z = trA(A)
Z = [A(1,:)'; A(2,:)'; A(3,3)];

function Z = getZ(u)
Z = zeros(7,9);
Z(1,[1,7]) = [-1, u(4)];
Z(2,[2,8]) = [-1, u(4)];
Z(3,[3,7,8]) = [-1, -u(1)*u(4), -u(2)*u(4)];
Z(4,[4,7]) = [-1, u(5)];
Z(5,[5,8]) = [-1, u(5)];
Z(6,[6,7,8]) = [-1, -u(1)*u(5), -u(2)*u(5)];
Z(7,[9,7,8]) = [-1, -u(1), -u(2)];

function Z = nd(A,B)
A = A'; B = B';

Z(:,3) = [0; 0; A(3);
          0; 0; A(6); 1];

Z(:,1) = [A(2)*B(1)-A(1)*B(4); A(2)*B(2)-A(1)*B(5);
          A(2)*B(3)-A(1)*B(6); A(5)*B(1)-A(4)*B(4);
          A(5)*B(2)-A(4)*B(5); A(5)*B(3)-A(4)*B(6); 0];

Z(:,2) = [A(1)*B(1)+A(2)*B(4); A(1)*B(2)+A(2)*B(5);
          A(1)*B(3)+A(2)*B(6); A(4)*B(1)+A(5)*B(4);
          A(4)*B(2)+A(5)*B(5); A(4)*B(3)+A(5)*B(6); 0];

function A = normu(u);
if size(u,1)==3, u = p2e(u); end

m = mean(u')'; % <=> mean (u,2)
u = u - m*ones(1,size(u,2));
distu = sqrt(sum(u.*u));
r = mean(distu)/sqrt(2);
A  = diag([1/r 1/r 1]);
A(1:2,3) = -m/r;

function e = p2e (u)
e = u(1:2,:) ./ ([1;1] * u(3,:));
