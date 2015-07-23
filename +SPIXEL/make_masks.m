function masks = make_spixel_masks(labels,labeling,spixels)
    num_spixels = max(spixels(:));
    num_dr = double(numel(labeling)-num_spixels);
    spixel_sites = [numel(labeling)-num_spixels+1:numel(labeling)];
    slabel_inds = unique(labeling(spixel_sites));
    slabels = labels(slabel_inds);

    for k = 1:numel(slabel_inds) 
        ssites = find(labeling == slabel_inds(k));
        active_spixels = ssites-num_dr;
        data{k} = ismember(spixels,active_spixels);
    end
    
    masks = struct('linf_id', ...
                   mat2cell([slabels(:).linf_id],1,ones(1,numel(slabel_inds))), ...
                   'data',data);