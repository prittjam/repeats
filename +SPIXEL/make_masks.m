function masks = make_masks(labels,labeling,spixels)
    num_spixels = max(spixels(:));
    num_dr = double(numel(labeling)-num_spixels);
    spixel_sites = [numel(labeling)-num_spixels+1:numel(labeling)];
    slabel_inds = unique(labeling(spixel_sites));
    slabels = labels(slabel_inds);

    linf_id = [slabels(:).linf_id];
    ulinf_id = unique(linf_id);

    for k = 1:numel(ulinf_id) 
        slabels_linf = find(linf_id == ulinf_id(k));
        ssites = [];
        for kk = 1:numel(slabels_linf)
            ssites = [ssites find(labeling == slabel_inds(slabels_linf(kk)))];
        end
        active_spixels = ssites-num_dr;
        data{k} = ismember(spixels,active_spixels);
    end
    
    masks = struct('linf_id', ...
                   mat2cell(ulinf_id,1,ones(1,numel(ulinf_id))), ...
                   'BW',data);

