function [active,BW] = get_active(segments,active)
BW = ismember(segments,active);
active = BW.*segments;