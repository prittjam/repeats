function timg = rectify(img,H,T1)
if nargin < 3
    T1 = [];
end

if ~isempty(T1)
    T = maketform('composite',T1, ...
                  maketform('projective',H'));
else
    T = maketform('projective',H');
end

timg = imtransform(img,T,'bicubic', ...
                   'Fill', 0, ...
                   'XYScale',1);