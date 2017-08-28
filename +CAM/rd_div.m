function v = rd_div(u,cc,q,varargin)
if abs(q) > 1e-10
    A = make_A(cc,varargin{:});
    
    m = size(u,1);
    if (m == 2)
        v = PT.homogenize(u);
    else
        v = u;
    end

    v = A*v;
    xu = v(1,:);
    yu = v(2,:);
    v(1:2,:) = [xu;yu]/2./(q*yu.^2+xu.^2*q).*(1-sqrt(1-4*q*yu.^2-4*xu.^2*q));
    v = inv(A)*v;
    
    if (m == 2)
        v = v(1:2,:);
    end
else
    v = u;
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
