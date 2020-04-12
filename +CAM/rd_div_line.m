function ld = rd_div_line(l, cc, q, varargin)
    display('CAM.rd_div_line is deprecated. Use LINE.distort_div');
    if abs(q) > 0
        A = make_A(cc, varargin{:});
        l0 = A' \ l;

        xc0 = - l0(1,:) ./ l0(3,:) ./ 2 ./ q;
        yc0 = - l0(2,:) ./ l0(3,:) ./ 2 ./ q;
        
        R = sqrt( (l0(1,:).^2 + l0(2,:).^2) ./...
                  (l0(3,:).^2) ./ 4 ./ (q.^2) - 1 ./ q);

        v = PT.homogenize([xc0; yc0]);
        v = A\v;
        R = R ./ A(1,1);
        
        ld = [v(1:2,:); R];
    else
        ld = l;
    end
end

function A = make_A(cc,varargin)
    cfg.rescale = false;
    cfg = cmp_argparse(cfg,varargin{:});    
    if cfg.rescale
        sc = sum(2*cc);
    else
        sc = 1;
    end    
    A = [1/sc   0  -cc(1)/sc; ...
         0   1/sc  -cc(2)/sc; ...
         0     0       1];
end    
