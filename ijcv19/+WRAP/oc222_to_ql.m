% Copyright (c) 2017 James Pritts
% 
classdef oc222_to_ql < WRAP.RectSolver
    properties
        name = 'H222ql';
        cartesian; 
    end

    methods
        function this = oc222_to_ql()
            this = this@WRAP.RectSolver('222');   
            this.cartesian = make_change_of_scale_constraints();
        end

        function M = fit(this,x,idx,cc,varargin)
            M = [];

            sc = 1;
            A = [1 0 -cc(1); ...
                 0 1 -cc(2); ...
                 0 0     1];            

            idx = reshape([idx{:}],1,[]);

            xn = A*x(:,idx); 
            s0  = varargin{1};

            s = s0(idx);
            
            x1 = xn(:,1:2:end);
            s1 = reshape(s(1:2:end),1,[]);           
            c1 = ones(1,numel(s1));

            x2 = xn(:,2:2:end);            
            s2 = reshape(s(2:2:end),1,[]);
            c2 = ones(1,numel(s2));

            tic
            [q,ll] = solver_rect_cos_222_refine(x1,s1,c1,x2,s2,c2);
            solver_time = toc;
            ll = [ll;ones(1,size(ll,2))];
            N = numel(q);

            if N > 0
                err = zeros(1,numel(q));
                for k = 1:numel(q)
                    si1 = this.cartesian.si_fn(1,ll(1,k),ll(2,k), ...
                                          q(k),s1,x1(1,:),x1(2,:));
                    si2 = this.cartesian.si_fn(1,ll(1,k),ll(2,k), ...
                                          q(k),s2,x2(1,:),x2(2,:));
                    err = abs(si1-si2);
                end
                ll2 = A'*ll;
                ll2 = ll2./ll2(3,:);
                M = struct('q', mat2cell(q,1,ones(1,N)), ...
                           'l', mat2cell(ll2,3,ones(1,N)), ...
                           'cc', cc, ...
                           'err', err, ...
                           'solver_time', solver_time);
            end
            
        end
    end
end
