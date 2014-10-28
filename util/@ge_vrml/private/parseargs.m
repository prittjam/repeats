function Params = parseargs( varargin )
% PARSEARGS     Treat named arguments of function
%    Params = PARSEARGS( [ key, value, ] ... [ pars ] ... ) returns 
%    structure of parameters. Pair key-value forms fields in the structure.
%    Fields can be also filled from given structure parameters. I.e., if 
%    argument is string, then it and the following is treated as
%    key-value pair. If the argument is structure, than its fields are 
%    added. 
%
%    Key-value pairs can be also entered as cell matrix - if the argument
%    on the place of key is cell, the pairs are filled from the cell
%    contents. This is usefull for calling from functions as 
%    PARSEARGS( varargin ). Cell argument works recursive.
%
%    In case of repeating keys, last value is preferred.
%
%    Example:
%      p1 = parseargs( 'key1', 1, 'key2', 'hey', 'key3', 'huh', 'key4', 'x' )
%
%      p2 = parseargs( 'key1', 1, ...
%                      struct( 'key2', 'hey', 'key3', 'huh' ), ...
%                      { 'key4', 'x' } )
%
%      p3 = parseargs( { 'key1', 1, { 'key2', 'hey' }, ...
%                        struct( 'key3', 'huh', 'key4', 'x' ) } )
%      % these examples should produce the same output

% (c) 2002-03-22, Martin Matousek
% $Date: 2005/11/02 15:27:40 $
% $Revision: 1.2 $


% iterate over input arguments, create and fill-in output fields

Params = struct;

i = 1;
l = length( varargin ); % cache the length, update only when changed

while( i <= l )
  if( ischar( varargin{i} ) )           % a key-value pair
    if( i == l )
      tx = [ 'Missing value to key ''' varargin{i} '''' ];
      throwAsCaller( MException( '', tx ) );
    end
    eval( [ 'Params.' varargin{i} ' = varargin{i+1};' ] );
    i = i + 2;                          % move i over this key followed by value
  
  elseif( isstruct( varargin{i} ) )     % structure
    for f = fieldnames( varargin{i} )';
      eval( [ 'Params.' f{1} ' = varargin{i}.' f{1} ';' ] );
    end
    i = i + 1; % move i over this structure
  
  elseif( iscell( varargin{i} ) )       % cell - interpolate
    varargin = [ varargin(1:i-1) varargin{i} varargin(i+1:end) ];
    l = length( varargin );             % update length
    % do not move i - process varargin{i} again in the next step
  
  else
    throwAsCaller(  MException( '', 'Wrong argument' ) );
  end
end

