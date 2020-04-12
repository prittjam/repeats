function A = make_norm_xform(varargin)
    cfg.norm_type = 'fitz';
    cfg.norm_params = [0 0];
    cfg = cmp_argparse(cfg, varargin{:});

    % type can be: fitz, diag, world
    if strcmp(cfg.norm_type, 'ray')
        K = cfg.norm_params;
        A = inv(K);
    elseif strcmp(cfg.norm_type, 'diag')
        cc = cfg.norm_params;
        sc = sqrt(sum((2*cc).^2)) / 2;
        A = make_A(cc, sc);
    else % fitz
        cc = cfg.norm_params;
        sc = sum(2*cc);
        A = make_A(cc, sc);
    end
end

function A = make_A(cc, sc)
    A = [1/sc   0  -cc(1)/sc; ...
         0   1/sc  -cc(2)/sc; ...
         0     0       1];
end