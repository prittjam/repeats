function [BW, T] = line2mask(l,im,mu,displacement)
if nargin < 4
    displacement = 0;
end
T = eye(3);
figure;
[~,line]=LINE.draw_extents(gca,l);
close;
line = LINE.stretch(line,10);
position = LINE.which_side(line,mu);
mask = [-1 1];
counts = histc(position,mask);
[max_val,ind] = max(counts);
% if max_val/sum(counts) < 0.95
%     BW = zeros(size(im,1),size(im,2));
%     return;
% end
[line2 T] = LINE.move(line,mask(ind)*displacement);
[n,m,~] = size(im);
[pixx, pixy] = meshgrid([1:m],[1:n]);
position = LINE.which_side(line2,[pixx(:) pixy(:)]');
BW = reshape(position == mask(ind),[n m]);
