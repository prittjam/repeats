function [is_degen] = one_to_one_degenfn(x, t)
is_degen = 0;


if (min([norm(x(1:3,1)-x(1:3,2)) norm(x(4:6,1)-x(4:6,2))]) < 0.01)
    is_degen = 1;
end

end