function [active,BW] = get_active(segments,active)
BW = uint32(ismember(segments,active));
active = BW.*uint32(segments);