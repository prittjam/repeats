function c = label_to_cell(segments,img)
    for active = [min(segments(:)):max(segments(:))]
        [~,BW] = SPIXEL.get_active(segments,active);
        c{active} = mask_to_pixels(BW,img);
    end