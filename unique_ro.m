function [rt,is_inverted] = unique_ro(rt)
is_inverted = rt(2,:) < 0;
rt(:,is_inverted) = Rt.invert(rt(:,is_inverted));
