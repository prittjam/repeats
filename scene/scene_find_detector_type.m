function work_done=scene_find_detector_type(chains)
%DETECT detects invalid regions according to DR.current in images
%   Assumes, that images with IMG_IDS have been loaded using LOAD_IMG.   

global DR RES;
work_done = 0;

if (nargin==1 & iscell(chains))
   % do whole detection phase
   ops  = cellfun(@(c) c(1), chains);
   if (any(ops == 0))
      % any work for detectors?
      work_done = 1;
      dchains = chains(ops==0);
      payload = cellfun(@(c) c(2:end)', dchains, 'uniformoutput', false);
      % throw away equal columns
      payload = unique([payload{:}]', 'rows')';
      imgs = unique(payload(1,:));
      gens = payload(2,:);
      % there is something to detect
      all_gens = {DR.defs.generator};
      selected_gens = unique(all_gens(gens));
      for i=imgs
         % for each detector (generator)
         for g=selected_gens
            % which DR van handle this generator
            handled = find(strcmp(all_gens, g));
            invalid = intersect(gens, handled);
            if (~isempty(invalid))
               switch (g{1})
                 case 'extrema'
                   detect_msers(i, invalid);
                   work_done=work_done+1;
                 case 'affpts'
                   detect_affpts(i, invalid);
                   work_done=work_done+1;
                 case 'affpts_sel'
                   detect_affpts_sel(i, invalid);
                   work_done=work_done+1;
                 case 'censure_t'
                   detect_censure(i, invalid, 'trspt');
                   work_done=work_done+1;
                 case 'censure_s'
                   detect_censure(i, invalid, 'simpt');
                   work_done=work_done+1;
                 case 'censure_a'
                   detect_censure(i, invalid, 'affpt');
                   work_done=work_done+1;
                 case 'star_detector_t'
                   detect_star_detector(i, invalid, 'trspt');
                   work_done=work_done+1;
                 case 'sfop_t'
                   detect_sfop(i, invalid);
                   work_done=work_done+1;
                 case 'cvsurf_t'
                   detect_cvsurf(i, invalid);
                   work_done=work_done+1;
                 case 'maver'
                   detect_maver(i, invalid);
                   work_done=work_done+1;                   
               end;
            end;
            % set default map from upgrade ids to dr ids
            for dr_id=invalid
               DR.data{i,dr_id}.upg2dr=1:DR.data{i,dr_id}.num_dr;
            end;
         end;
      end;
      % we have performed all detection operations
      chains=chains(ops~=0);
   end;
else
   if nargin<1
      img_ids=1:num_imgs;
   else
      img_ids=chains;
   end;
   
   for i=img_ids
      invalid = intersect(find(DR.valid(i,:)==0), DR.current);
      work_done=work_done+detect_dr(i, invalid);
   end;

   RES.stats=dr_stats;
end;