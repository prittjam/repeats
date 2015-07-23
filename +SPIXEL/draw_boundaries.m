function [] = draw_boundaries(gca,segments,varargin)
if nargin < 3
    varargin = {'r.','MarkerSize',2};
end

perim = false(size(segments,1),size(segments,2));
for k = 1:max(segments(:))
    regionK = segments == k;
    perimK = bwperim(regionK,4);
    perim(perimK) = true;
end
[ii,jj] = find(perim);
hold on;
plot(gca,jj,ii,varargin{:});
hold off;