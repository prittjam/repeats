function ratio = overlap_ratio(segments,BWimg)
for active = [min(segments(:)):max(segments(:))]
    [~,BW] = SPIXEL.get_active(segments,active);
    overlap = BW.*uint32(BWimg);
    ratio(active) = sum(overlap(:))/sum(BW(:));
end