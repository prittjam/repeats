function [] = draw_boundaries(gca,segments,varargin)
cfg = struct('segments',1:max(segments(:)), ...
             'markersize',2);
leftover = {};
[cfg,leftover] = cmp_argparse(cfg,varargin{:});

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