function xc = make_random(num_lafs)
x = reshape([rand(2,3*num_lafs); ...
             ones(1,3*num_lafs)],9,[]);
s = LAF.is_right_handed(x);
x(:,s) = LAF.switch_hands(x(:,s));
xc = LAF.translate(x,-x(4:5,:));
