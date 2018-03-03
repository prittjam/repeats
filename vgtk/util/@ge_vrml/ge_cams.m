function ge = ge_cams( ge, ptrack, varargin )
% GE_VRML/GE_CAMS       Export of cameras as viewpoints.
%    ex = ge_cams( ex, ptrack, varargin )
%
%    ptrack = {P1, P2, ... }

% (c) 2007-11-02, Martin Matousek
% Last change: $Date$
%              $Revision$


opt = parseargs( 'fov', 0, 'plot', 0, ...
                 'idstart', 1, 'xrot', eye(3), 'tour', 0, varargin{:} );

fh = ge.fh;

ncams = length( ptrack );


if( opt.tour )
  name = 'GGE';

  for i = length( ptrack ):-1:1
    P = ptrack{i};
  
    if( ~isreal( P ) ), error( 'Matrix P is complex.' ); end
    [K R t(:,i)] = P2KRt( P ); %#ok

    Rx = opt.xrot*diag([1 -1 -1])*R;
    [ax(:,i) ang(1,i)] = R2aa(  Rx );%#ok
    ang(1,i)=-ang(1,i);%#ok
  end

%  time = vlen(diff(t,[],2));
  time = ones( ncams, 1 ) * 10;
  dtime = cumsum( time ) / sum( time );

  
  
  
  fprintf(fh, 'DEF %stour Viewpoint {\n', name);
  fprintf(fh, 'position  %.10f %.10f %.10f\n', t(:,1) );
  fprintf(fh, 'orientation %.10f %.10f %.10f %.10f\n', ax(:,1), ang(1) );
  if( opt.fov )
    fprintf( fh, 'fieldOfView %f\n', opt.fov );
  end
  fprintf(fh, 'description "Start The Tour"\n' );

  fprintf(fh, '}\n\n');
  
  fprintf(fh, 'DEF %stime TimeSensor { cycleInterval %d\n\t\t\tloop TRUE\n}\n\n',...
          name, opt.tour);
  
  fprintf(fh, 'DEF %sPosInt PositionInterpolator {\n', name);
  fprintf(fh, 'key [');
  fprintf(fh, ' %.10f ', dtime ); 
  fprintf(fh, ']\n');
  fprintf(fh, 'keyValue [ %.10f %.10f %.10f', t(:,1));
  fprintf(fh, ', %.10f %.10f %.10f', t(:,2:end));
  fprintf(fh, ']\n}\n\n');

  fprintf(fh, 'DEF %sOriInt OrientationInterpolator {\n', name);
  fprintf(fh, 'key [');
  fprintf(fh, ' %.10f ', dtime);
  fprintf(fh, ']\n');
  fprintf(fh, 'keyValue [ %.10f %.10f %.10f %.10f', ax(:,1), ang(1));
  fprintf(fh, ', %.10f %.10f %.10f %.10f', [ ax(:,2:end); ang(1,2:end) ]);
  fprintf(fh, ']\n}\n\n');
  
  fprintf(fh, 'ROUTE %stour.bindTime TO %stime.set_startTime\n', name, name);
  fprintf(fh, 'ROUTE %stime.fraction_changed TO %sPosInt.set_fraction\n', name, name);
  fprintf(fh, 'ROUTE %stime.fraction_changed TO %sOriInt.set_fraction\n', name, name);
  fprintf(fh, 'ROUTE %sPosInt.value_changed TO %stour.set_position\n', name, name);
  fprintf(fh, 'ROUTE %sOriInt.value_changed TO %stour.set_orientation\n\n', name, name);

end

for i = 1:length( ptrack )
  P = ptrack{i};
  
  if( ~isreal( P ) ), error( 'Matrix P is complex.' ); end
  [K R t] = P2KRt( P );
  d = inv( R ) * [0;0;1] * 0.1;

  Rx = opt.xrot*diag([1 -1 -1])*R;
  [ax ang] = R2aa(  Rx );
  ang=-ang;
    
  ViewPoint( fh, t, ax, ang, opt.fov, opt.idstart+i-1 )
  if( opt.plot )
    % for j = 1:10
    %   bulb( fh, t+d*j, [0;1;0], 0.01 );
    % end
    
    % for j = 1:10
    %   bulb( fh, t-d*j, [1;0;0], 0.01 );
    % end
    
    bulb( fh, t, [1;1;0], 0.01 );
  end
end
  
function ViewPoint( fh, t, ax, ang, fov, id )
fprintf( fh, 'Viewpoint {\n' );
fprintf( fh, 'position %f %f %f\n', t );
fprintf( fh, 'orientation %f %f %f %f\n', ax, ang );
fprintf( fh, 'description "Camera %i"\n', id );
if( fov )
  fprintf( fh, 'fieldOfView %f\n', fov );
end
fprintf( fh, '}\n' );

