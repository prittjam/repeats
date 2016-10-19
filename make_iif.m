function iif = make_iif(varargin)
iif =  varargin{2*find([varargin{1:2:end}],1,'first')}();