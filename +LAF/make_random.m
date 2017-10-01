function u = make_random(num_lafs)
u = reshape([rand(2,3*num_lafs); ...
             ones(1,3*num_lafs)],9,[]);
s = LAF.is_right_handed(u);
u(:,s) = LAF.switch_hands(u(:,s));
