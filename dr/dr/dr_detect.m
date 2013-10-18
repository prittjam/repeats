function res = dr_detect(dr_cfg,dr,img)
drids = dr_get_drids(dr_cfg,dr);
gens = dr_get_generators(dr_cfg,dr);
selected_gens = unique(gens);
res = cell(1,numel(drids));
for g=selected_gens
    % which DR van handle this generator
    for g=selected_gens
        % which DR van handle this generator
        handled = find(strcmp(gens, g));
        if (~isempty(handled))
            switch (g{1})
              case 'extrema'
                res(handled) = dr_detect_msers(dr_cfg,dr(handled),img);
              case 'affpts'
                detect_affpts(i, invalid);
              case 'affpts_sel'
                detect_affpts_sel(i, invalid);
              case 'censure_t'
                detect_censure(i, invalid, 'trspt');
              case 'censure_s'
                detect_censure(i, invalid, 'simpt');
              case 'censure_a'
                detect_censure(i, invalid, 'affpt');
              case 'star_detector_t'
                detect_star_detector(i, invalid, 'trspt');
              case 'sfop_t'
                detect_sfop(i, invalid);
              case 'cvsurf_t'
                detect_cvsurf(i, invalid);
              case 'maver'
                detect_maver(i, invalid);
            end
        end
    end
    work_done = ~cellfun(@isempty,res);
    for k = find(work_done)
        res{k}.upg2dr = 1:res{k}.num_dr;
        res{k}.name = dr(k).name;
    end
end