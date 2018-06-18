function masks = labeling_to_masks(segments,labels,labeling)
num_segments = max(segments(:));
num_dr = double(numel(labeling)-num_segments);
spixel_sites = [numel(labeling)-num_segments+1:numel(labeling)];
slabel_inds = unique(labeling(spixel_sites));
slabels = labels(slabel_inds);

for k = 1:numel(slabel_inds) 
    ssites = find(labeling == slabel_inds(k));
    active_segments = ssites-num_dr;
    masks{k} = ismember(segments,active_segments);
end

masks = struct('label',mat2cell([slabels(:)],1,ones(1,numel(slabel_inds))), ...
               'BW',mask);