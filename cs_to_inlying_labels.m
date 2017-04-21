function G = cs_to_inlying_labels(labeling,cs,IJ)
G = labeling.*cs;
G(G==0) = nan;
G = findgroups(G);
