function G = circle_to_vp_label(c,varargin)
    cfg = struct('vqT', 100, ...
                 'min_support', 6);
    [cfg,~] = cmp_argparse(cfg,varargin{:});
     
    x = [c(1:2,:); ...
         ones(1,size(c,2))];
    G = nan(1,size(x,2));
    
    if size(x,2) > 1
        cspond = nchoosek(1:size(x,2),2);
    
        l = cross(x(:,cspond(:,1)), ...
                x(:,cspond(:,2)));
        l = l./sqrt(sum(l(1:2,:).^2));
    
        m = size(x,2);
        n = size(l,2);
    
    
        N_MAX = 5000;
        if n > N_MAX
            ind = randi(n,1,N_MAX);
            l = l(:,ind);
            cspond = cspond(ind,:);
            n = N_MAX;
        end
    
        d2 = reshape(abs(x'*l),m,n);
    
        newcspond = zeros(4,n);
        newcspond(1,:) = cspond(:,1);
        newcspond(2,:) = 1:n;
        newcspond(3,:) = cspond(:,2);
        newcspond(4,:) = 1:n;
        newcspond = reshape(newcspond,2,[]);
    
        ind = sub2ind(size(d2),newcspond(1,:),newcspond(2,:));
        d2(ind) = inf;
    
        K = sparse(double(d2 < cfg.vqT));
    
        num_good = sum(K);
    
        ind = num_good >= cfg.min_support;
        if isempty(nonzeros(ind))
            G = 1:size(c,2);
        else
            K = K(:,ind);
    
            nck = [];
            for k = 1:size(K,2)
                nck = cat(1,nck,nchoosek(find(K(:,k)),2));
            end
    
            A0 = adjacency(graph(nck(:,1),nck(:,2)));
            A = sparse(nck(:,1),nck(:,2), ...
                    ones(size(nck,1),1),m,m);
            A = A+A';
            A = A/max(A(:));
            [G,V,D] = spectralcluster(A,10, ...
                                    'Distance','precomputed');
            G = reshape(G,1,[]);
        end
    end
end