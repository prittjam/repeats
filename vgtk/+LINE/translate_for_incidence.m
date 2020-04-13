function l2 = translate_for_incidence(l, x)
    % l -- line to translate
    % x -- point that should be incident with the translated line l2
    t = ones(2, size(x,2));
    if l(1) ~= 0
        t(1,:) = (l(2) .* (x(2,:) - t(2,:)) + l(3)) ./ l(1) + x(1,:);
    end
    % t = t ./ vecnorm(t);
    l2(3,:) = l(3) - t(1,:) .* l(1) - t(2,:) .* l(2);
    l2(1,:) = l(1); l2(2,:) = l(2);
end