%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function ge = ge_close( ge )
% GE_VRML/GE_CLOSE      Close.
%    ex = ge_close( ex )

% (c) 2007-11-02, Martin Matousek
% Last change: $Date$
%              $Revision$

fclose( ge.fh );
ge.fh = [];
ge.file = [];
