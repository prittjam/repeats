%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function rimg = rectify_inliers_cf(im,Hinf,dr,inl_idx)
linf = Hinf(3,:)';
inl_idx = inl_idx(cellfun(@numel, inl_idx) > 1);        
u2 = dr.u(:,unique([inl_idx{:}]));
mu2 = dr.mu(:,unique([inl_idx{:}]));
rimg = [];
if ~isempty(u2)
    v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u2);
    A = HG.laf1_to_A([v;u2]);
    H = A*Hinf;
    BW = close_form(H,im,mu2);

    inboundary = find_inboundary(BW);
    rimg = IMG.rectify_part(im,H,inboundary);
else
    warning('No inliers. Skipping...');
end

function BW = close_form(H,im,mu2)
linf = H(3,:);

figure;
[~,line]=LINE.draw_extents(gca,linf');
close;
line = LINE.stretch(line,10);
position = LINE.which_side(line,mu2);
mask = [-1 1];
counts = histc(position,mask);
[max_val,ind] = max(counts);
direction = -mask(ind);
