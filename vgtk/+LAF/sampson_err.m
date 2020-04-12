%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function err = sampson_err(u,H)
u2 = [reshape(u(1:9,:),3,[]); ...
      reshape(u(10:18,:),3,[])];
err = reshape(fHDs(inv(H),u2),3,[]);