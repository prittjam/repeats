%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function H = hg_2elin(Ca, Cb)

% function H = hg_2elin(Ca, Cb)
% correspondences: Ca(:,:,i) <-> Cb(:,:,i).
%
% INPUT
%  Real symmetric nonsingular 3x3xN matrices:
%    Ca(:,:,i)- the conic coefficient matrices in the first view
%    Cb(:,:,i) - the corresponding conics in the second view
%
% For more details see  Chum, Matas ICPR 2012:.
% Homography Estimation from Correspondences of Local Elliptical Features
%
% (C) Ondra Chum 2012


for i = 1:size(Ca,3)
  Ns(:,:,i) = inv(C2A(Ca(:,:,i)));
  Ds(:,:,i) = C2A(Cb(:,:,i));
end

H = AntoRH (Ns, Ds);
