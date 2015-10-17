function ratio = overlap_ratio(segments,BWimg)
for active = [min(segments(:)):max(segments(:))]
    [~,BW] = SPIXEL.get_active(segments,active);
    overlap = BW.*BWimg;
    ratio(active) = sum(overlap(:))/sum(BW(:));
end