function [] = draw_boundaries(gca,segments,varargin)
N = max(segments(:));
cfg = struct('segments',1:N, ...
             'markersize',10);
[cfg,leftover] = cmp_argparse(cfg,varargin{:});
if isempty(leftover)
	leftover = {};
end

perim = false(size(segments,1),size(segments,2));
for k = cfg.segments
    regionK = segments == k;
    perimK = bwperim(regionK,4);
    perim(perimK) = true;
end

[ii,jj] = find(perim);
hold on;
plot(gca,jj,ii,'.','MarkerSize', ...
     cfg.markersize,leftover{:});
hold off;