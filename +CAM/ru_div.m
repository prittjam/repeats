function v = ru_div(u,cc,q,varargin)
if abs(q) > 1e-10
    A = make_A(cc,varargin{:});
    
    m = size(u,1);

    if (m == 2)
        u = [u;ones(1,size(u,2))];
    end
    
    v = A*u;
    dv = 1+q*(v(1,:).^2+v(2,:).^2);
    v(1:2,:)  = v(1:2,:)./dv; 
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
