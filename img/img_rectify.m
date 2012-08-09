function timg = img_rectify(img,H,T1)
if ~isempty(T1)
    T = maketform('composite',T1, ...
                  maketform('projective',H'));
else
    T = maketform('projective',H');
end

timg = imtransform(img,T,'bicubic','Fill', 0);