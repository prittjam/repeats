function [tc,dr1,dr2] = scene_flatten_tc(ctc,cdr1,cdr2)
tc = [];
for k = 1:numel(ctc)
    if ~isempty(ctc(k).m)
        tc = cat(2,tc, ...
                 [cdr1(k).gid(ctc(k).m(1,:)); ...
                  cdr2(k).gid(ctc(k).m(2,:))]);
    end
end