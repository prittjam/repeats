function mkdir_for_file( file )
%MKDIR_FOR_FILE  Creates necessary directory structure for given file.
%
%   mkdir_for_file( FULL_FILENAME ) missing parent subdirectories necessary for
%   saving the file. It is correct if some or all subdirectories allready exist.

% (c) 2007-11-27, Martin Matousek
% Last change: $Date::                            $
%              $Revision$

wstate = warning( 'off', 'MATLAB:MKDIR:DirectoryExists' );

path = fileparts( file );

if( isempty( path ) ), warning( wstate ); return; end

[success, message, msgid] = mkdir( path );

warning( wstate );

if( ~success ), error( msgid, message ); end

if( ~exist( path, 'dir' ) )
  error( 'mkdir_for_file:failed', ...
         'Make directory %s failed. (%s)', path, message );
end
