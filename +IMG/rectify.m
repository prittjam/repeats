function [timg,xdata,ydata] = rectify(img,H,T1)
if nargin < 3
    T1 = [];
end

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
                                 'Fill', 0, ...
                                 'XYScale', 1);