function [a sin_alpha cos_alpha] = R2aa( R )
%R2AA  Rotation matrix to axis-angle (inverted Rodrigues' formula).
%   [a] = R2aa( R )
%   [a alpha] = R2aa( R )
%   [a sin_alpha cos_alpha] = R2aa( R )
%
%   Input:
%     R     - 3x3 rotation (othogonal) matrix.
%
%   Output:
%     a     - rotation axis. If alone, its length is the angle, otherwise unit.
%     alpha - angle of rotation around the axis.
%
%   See also AA2R.

% (c) 2007-05-23, Martin Matousek
% Last change: $Date:: 2009-04-21 18:53:58 +0200 #$
%              $Revision: 37 $

% Can be solved using logm(R) (excluding rotation by 0 and pi), but
% the following is faster.

dR = det( R );
if( dR < 0 )
  error( 'Rotation matrix must have positive unit determinant' );
end

% To derive the following, examine Rodrigues' rotation formula for R - R':
%   R - R' = 2 * sqc( a ) * sin( alpha )
% and for Tr(R):
%   trace( R ) = 1 - 2 * cos( alpha )

sa = [R(3,2)-R(2,3); R(1,3)-R(3,1); R(2,1)-R(1,2)] / 2; % sin_alpha * ax

sin_alpha = sqrt( sum( sa.^2 ) );
cos_alpha = ( trace(R) - 1 ) / 2;

if( sin_alpha == 0 ) % hard zero test suffices (see note bellow)
  a = [1;0;0];
else
  a = sa / sin_alpha;
  % This has standard accuracy for alpha > sqrt( realmin ). Then the accuracy
  % smoothly degrades as alpha approaches sqrt( eps(0) ). For 
  % alpha <= sqrt( eps(0) ) we compute sin_alpha = 0 because of square there.
  % Overal, the accuracy of 'sa' here is better than using EIG.
end

if( nargout < 3 )  % [a alpha] required
  sin_alpha = atan2( sin_alpha, cos_alpha );

  if( nargout < 2 )  % a required
    a = a * sin_alpha;
  end
end
