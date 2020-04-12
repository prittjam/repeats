function v = distort_bc(u, k, varargin)
    if any(k) > 0
        p = k(3:4);
        k = k([1:2, 5:end]);

        A = CAM.make_norm_xform(varargin{:});
        m = size(u,1);
    
        if (m == 2)
            u = [u;ones(1,size(u,2))];
        end
        
        v = A * u;
        r2 = sum(v(1:2,:).^2,1);
        pows = (1:numel(k)) .* (k~=0);
        kv = (1 + (r2'.^(pows)) * k')';
        dv(1,:) = 2 .* p(1) .* v(1,:) .* v(2,:) + p(2) .* (r2 + 2 .* v(1,:).^2);
        dv(2,:) = 2 .* p(2) .* v(1,:) .* v(2,:) + p(1) .* (r2 + 2 .* v(2,:).^2);
        v(1:2,:) = bsxfun(@times, v(1:2,:), kv) + dv;
        v = A \ v;
    
        if (m == 2)
            v = v(1:2,:);
        end
    else
        v = u;
    end
end