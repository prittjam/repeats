function segments = relabel(segments0)
valid_labels = [min(segments0(:)):max(segments0(:))];
segments = zeros(size(segments0));
last_label = 0;
for k = valid_labels
    BW = bwlabeln(ismember(segments0,k));
    segments = segments+BW+((BW>0).*last_label);
    last_label = max(segments(:));
end
