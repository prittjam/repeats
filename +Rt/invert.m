function Rt = invert(Rt)
    Rt(1,:) = -Rt(1,:);
    c = cos(Rt(1,:));
    s = sin(Rt(1,:));
    a11 = Rt(4,:);
    Rt(2:3,:) = -[ a11.*c.*Rt(2,:)-a11.*s.*Rt(3,:); ...
                   s.*Rt(2,:)+c.*Rt(3,:) ]; 
