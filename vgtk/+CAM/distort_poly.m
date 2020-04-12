function v = distort_poly(u, k, varargin)
    if any(k) > 0
        A = CAM.make_norm_xform(varargin{:});
        m = size(u,1);
    
        if (m == 2)
            u = [u;ones(1,size(u,2))];
        end
    
        v = A * u;
        r2 = sum(v(1:2,:).^2,1);

        pows = (1:numel(k)) .* (k~=0);
        dv = (1 + (r2'.^(pows)) * k')';
        v(1:2,:)  = bsxfun(@times, v(1:2,:), dv); 
        v = A \ v;
    
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end