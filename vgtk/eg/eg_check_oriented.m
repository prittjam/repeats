function is_degen = eg_check_oriented(u,sample,weights,F, ...
                                      cfg)
m = numel(F);
is_degen = false(1,m);
for k = 1:m
    a = eg_get_orientation(u(:,sample),F{k});
    is_degen(k) = any(a ~= a(1));
end