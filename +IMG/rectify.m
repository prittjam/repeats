function [timg,xdata,ydata] = rectify(img,H,T1,varargin)
if nargin < 3
    T1 = [];
end
cfg.fill = 0;
cfg = cmp_argparse(cfg,varargin{:});

if all(size(H) == [1 3])
	H = [1 0 0; 0 1 0; H];
end

if ~isempty(T1)
    T = maketform('composite',T1, ...
                  maketform('projective',H'));
else
    T = maketform('projective',H');
end

[timg,xdata,ydata] = imtransform(img,T,'bicubic', ...
                                 'Fill', cfg.fill, ...
                                 'XYScale', 1);