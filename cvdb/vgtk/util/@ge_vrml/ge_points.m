function ge = ge_points( ge, X, varargin )
% GE_VRML/GE_POINTS     Export of points.
%    ex = ge_points( ex, X, varargin )

% (c) 2007-11-02, Martin Matousek
% Last change: $Date$
%              $Revision$

opt = parseargs( 'color', [1 1 1]', 'bulb', 0, 'box', 0, varargin{:} );

fh = ge.fh;

npt = size( X, 2 );
nc = size( opt.color, 2 );

if( nc ~= npt && nc ~= 1 && size( opt.color, 1 ) ~= 3 )
  error( 'color must be 3x1 or 3xn vector' );
end

if( opt.bulb > 0 )
  for i = 1:npt
    if( size(opt.color,2) == npt ), C = opt.color(:,i); else C = opt.color; end
    bulb( fh, X(:,i), C, opt.bulb )
  end

elseif( opt.box > 0 )
  for i = 1:npt
    if( size(opt.color,2) == npt ), C = opt.color(:,i); else C = opt.color; end
    box( fh, X(:,i), C, opt.box([1 1 1]) )
  end

else
  fprintf( fh, 'Shape {\n' );
  fprintf( fh, ' geometry PointSet {\n' );
  fprintf( fh, '  coord Coordinate {\n' );
  fprintf( fh, '   point [\n' );
  
  len = size(X,2);
  
  fprintf( fh, '    %f %f %f,\n', X );
  
  fprintf( fh, ']\n}\n' );
  
  fprintf( fh, ' color Color {\n' );
  fprintf( fh, '  color [\n' );
  
  if( size( opt.color, 1 ) ~= 3 )
    error( 'color must be 3x1 or 3xn vector' );
  end
  
  if( size( opt.color, 2 ) == len )
    fprintf( fh, '    %f %f %f,\n', opt.color );
  elseif( size( opt.color, 2 ) == 1 )
    fprintf( fh, '    %f %f %f,\n', opt.color( :, ones( 1, len ) ) );
  else
    error( 'color must be 3x1 or 3xn vector' );
  end
  
  fprintf( fh, ']\n}\n}\n}\n' );

end
