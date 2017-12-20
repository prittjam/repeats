function bulb( fh, X, C, r )
fprintf( fh, 'Transform {\n' );
fprintf( fh, '      translation %f %f %f\n', X(1), X(2), X(3) );
fprintf( fh, '      children [\n' );
fprintf( fh, '        Shape {\n' );
fprintf( fh, '          geometry Sphere { radius %f}\n', r(1) );
fprintf( fh, '          appearance Appearance {\n' );
fprintf( fh, '            material Material { diffuseColor 0 0 0\n' );
fprintf( fh, '                                emissiveColor %f %f %f}\n', ...
         C(1), C(2), C(3) );
fprintf( fh, '         }\n' );
fprintf( fh, '        }\n' );
fprintf( fh, '      ]\n' );
fprintf( fh, '    }\n' );
