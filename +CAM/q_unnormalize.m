function q = q_unnormalize(q, varargin)
    cfg.norm_type = 'fitz';
    cfg.norm_params = [0 0];
    cfg = cmp_argparse(cfg, varargin{:});

    % type can be: fitz, diag, world
    if strcmp(cfg.norm_type, 'ray')
        K = cfg.norm_params;
        sc = K(1,1); % f
    elseif strcmp(cfg.norm_type, 'diag')
        cc = cfg.norm_params;
        sc = sqrt(sum((2*cc).^2)) / 2;
    else % fitz
        cc = cfg.norm_params;
        sc = sum(2*cc);
    end
    q = q / (sc^2);
end