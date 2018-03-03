function [K, R, t] = P2KRt( P )
%P2KRT  Decomposition of projective camera matrix.
%   [K, R, t] = P2KRt( P ) decomposes 3x4 projective camera matrix.
%
%   Input:
%     P     - 3x4 projective camera matrix, P = [Q | q], where Q is 3x3
%             regular matrix (i.e. P is not an affine camera). 
%
%   Output:
%     K     - 3x3 upper triangular matrix of camera internal parameters. 
%             K is normalised such that K(1,1) > 0 and K(3,3) > 0.
%
%     R     - 3x3 camera rotation matrix.
%
%     t     - camera center, euclidean vector (3x1)
%
%
%   Q is decomposed using QR decomposiotion as Q = K*R. Then 
%   t = - inv(Q) * q  and 
%        P = [K*R|-K*R*t]
%   holds.

% (c) 2003-10-13, Martin Matousek
% Last change: $Date:: 2008-01-31 17:40:18 +0100 #$
%              $Revision: 7 $

Q = P(:,1:3);
if( rank( Q ) < 3 ), error( 'P(1:3,1:3) must have full rank' ); end
t = - inv( Q ) * P(:,4);

[R K] = qr( inv( Q ) );
R = R';
K = inv(K);

% correction - det(R) > 0
if( det(R) < 0 ) 
  R = -R;
  K = -K;
end

% correction - K to normalised form (K(1,1)>0, K(3,3)>0)

f = diag(K) < 0;

if( f(1) && f(3) ) 
  C = [-1 0 0; 0 1 0; 0 0 -1];
  R = C*R; K = K*C;
elseif( f(1) ) 
  C = [-1 0 0; 0 -1 0; 0 0 1];
  R = C*R; K = K*C;
elseif( f(3) )
  C = [1 0 0; 0 -1 0; 0 0 -1];
  R = C*R; K = K*C;
else
  % OK
end
