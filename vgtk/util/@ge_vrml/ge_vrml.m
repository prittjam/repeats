function ge = ge_vrml( file )
% VGE_VRML/GE_VRML      Geom export: vrml constructor.
%    ge = ge_vrml( file )

% (c) 2007-11-02, Martin Matousek
% Last change: $Date$
%              $Revision$

mkdir_for_file( file )
fh = fopen( file, 'w' );

if( fh < 0 ),
  error( [ 'Cannot wopen file ''' file '''' ] );
end

ge = struct( 'file', file, 'fh', fh );
ge = class( ge, 'ge_vrml' );

fprintf( fh, '#VRML V2.0 utf8\n' );
