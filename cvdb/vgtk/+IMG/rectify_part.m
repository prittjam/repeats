function [timg,xdata,ydata] = rectify_part(im,H,inbounds,varargin)
timg = [];
xdata = [];
ydata = [];
if isempty(inbounds)
	return;
end
cfg.fill = 0;
cfg = cmp_argparse(cfg,varargin{:});

T = maketform('projective',H');
imbounds = [1 1; size(im,2) size(im,1)];

outimbounds = findbounds(T,imbounds);
[X,Y] = tformfwd(T,inbounds(:,1),inbounds(:,2));
outbounds = [X Y];
outbounds = [min(outbounds); max(outbounds)];

data = [max(outbounds(1,:),outimbounds(1,:));
 		min(outbounds(2,:),outimbounds(2,:))];

if max(data(2,:) - data(1,:)) > 8000
	xdata = data;
	return;
end

[timg,xdata,ydata] = imtransform(im,T,'bicubic', ...
                                 'Fill', cfg.fill, ...
                                 'XYScale', 1, ...
                                 'XData', data(:,1)', ...
                                 'YData', data(:,2)');

mask1 = logical(sum(timg,3));
mask2 = logical(sum(mask1,1));
mask3 = logical(sum(mask1,2));

timg = timg(mask3,mask2,:);
