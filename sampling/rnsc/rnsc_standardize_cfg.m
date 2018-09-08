%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function cfg = rnsc_standardize_cfg(cfg)
    if ~isfield(cfg, 'min_trials')
        cfg.min_trials = 0;
    end

    if ~isfield(cfg, 'max_trials')
        cfg.max_trials = 1e5;
    end

    if ~isfield(cfg, 'max_data_retries')
        cfg.max_data_retries = 1e3;
    end

    if ~isfield(cfg, 'sample_fn')                    
        cfg.sample_fn = @rnsc_samp_uniform;
    end

    if ~isfield(cfg, 'sample_args')
        cfg.sample_args = {};
    end    

    if ~isfield(cfg, 'sample_degen_fn')
        cfg.sample_degen_fn = @(u,sample,varargin) false;
    end

    if ~isfield(cfg, 'sample_degen_args')
        cfg.sample_degen_args = {};
    end

    if ~isfield(cfg, 'est_args')
        cfg.est_args = {};
    end

    if ~isfield(cfg, 'objective_fn')
        cfg.objective_fn = @rnsc_objective_fn;
    end