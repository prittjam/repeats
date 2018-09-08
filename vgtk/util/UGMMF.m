%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef UGMMF
    methods(Static)
        
        function [label, model, llh, R, X] = ugmmf_em(u,s,U,maxiter,cfg,F0)

        % Expectation-Maximization estimation of UGMMF parameters.
        % This function learns the parameters of a Gaussian Mixture Model 
        % (UGMMF) using a recursive Expectation-Maximization (EM) algorithm, starting 
        % from an initial estimation of the parameters.
        %
        %
        % Inputs -----------------------------------------------------------------
        %   X:    D x N array representing N datapoints of D dimensions.
        %   
        % Outputs ----------------------------------------------------------------
        %   o label:   array representing to one of the K UGMMF components. values in
        %   arnge 1:K
        %   o model: {mu, Sigma, Prior}
        %     mu:      D x K array representing the centers of the K UGMMF components.
        %     Sigma:   D x D x K array representing the covariance matrices of the 
        %              K UGMMF components.
        %     Prior:   Prior probability of each of K classes
        %   o llh:     LogLikelihood on each iteration of algorithm

        
        if nargin < 3
            maxiter = 500;
        end
        
        tol = 1e-6;        
        llh = -inf(1,maxiter);
        model = [];
        converged = false;
        t = 1;

%         fprintf('EM for Gaussian mixture: running ... \n');

        %% initialization // E-step

        [R,X,F,Sigma] = UGMMF.initialization(u,s,U,cfg,F0);
        [~, label(1,:)] = max(R,[],2);
        R = R(:, unique(label));

        %% algorithm

        while ~converged && t <= maxiter && sum(label == 1) > 7
            t = t + 1;
            %% M-step
            [model,X] = UGMMF.maximization(R,U,u,F, ...
                                           diag([Sigma Sigma Sigma Sigma]));

            %% E-step
            [R, llh(t)] = UGMMF.expectation(X, model);
            %%
            [~, label(1,:)] = max(R,[],2);
            idx = unique(label);

            if size(R,2) ~= size(idx,2)
               R = R(:,idx); 
            else 
               converged = llh(t)-llh(t-1) < tol*abs(llh(t));
            end
            F = model.F;
            Sigma = model.Sigma;
        end

        if converged
            fprintf('Converged in %d steps.\n',t-1);
        else
            fprintf('Not converged in %d steps.\n',maxiter);
        end

        end
        
     
        %% evaluate data log Probability
        function logPx = logProbability(X, model)
            
            if isempty(model)
               logPx = ones(1,size(X,2)) * -10000;
               return;
            end
            
            n = size(X,2);
            k = size(model.mu, 2);            
            logPxi = zeros(n, k);

            for i = 1:k, logPxi(:,i) = UGMMF.loggausspdf(X, model.mu(:,i), model.Sigma(:,:,i)); end

            logPxi = bsxfun(@plus, logPxi, log(model.prior));
            logPx = UGMMF.logsumexp(logPxi, 2);
            
        end
    
    end
    
    methods(Static,Access=public)
        
        %% maximization step
        function [model,X] = maximization(R,U,u,F,Sigma0)
        model.F = eg_est_F_from_7p_mle(u,F,'Weights',R(:,1), ...
                                       'Algorithm','Default');
        X = eg_sampson_F_dist(u,model.F);

        [d, n] = size(X);
        k = size(R, 2)-1;

        s = sum(R,1);
        model.prior = s/n;

        Sigma = zeros(1,k);

        for i = 1:k
            Xo = bsxfun(@times,X,sqrt(R(:,i)'));
            Sigma(:,:,i) = sum(sum(Xo.^2))/s(i)/d;
            Sigma(:,:,i) = Sigma(:,:,i)+(1e-6); % added for
            %numerical stability
        end

        model.Sigma = Sigma;
        model.U = U;
       
        end

        %% exapectation step
        function [P, llh] = expectation(X, model)
            Sigma = model.Sigma;
            prior = model.prior;
            U = model.U;

            n = size(X, 2);
            k = 1;
            logPxi = zeros(n, k+1);

            for i = 1:k, logPxi(:,i) = UGMMF.loggausspdf(X, zeros(4,1), ...
                                                         Sigma(:,:,i)); end
            logPxi(:,k+1) = log(U);

            logPxi = bsxfun(@plus, logPxi, log(prior));
            logPx = UGMMF.logsumexp(logPxi, 2);

            llh = sum(logPx)/n; % loglikelihood
            logPix = bsxfun(@minus,logPxi,logPx);

            P = exp(logPix);
        end
        
        %% initialization
        function [R,X,F,Sigma] = initialization(u,s,U,cfg,F)
            X = eg_sampson_F_dist(u,F);
            %            [~,s] = orsa_objective_fn(X,[],[],[],cfg,4);
            s2 = sum(X.^2,1) < 4*cfg.tsq;

%            a = eg_get_orientation(u(:,s),F);
%            s2 = false(1,size(s,2));
%            s2(s) = (a == mode(a));

            F = eg_est_F_from_8p(u,s2);

            %            model.F = eg_est_F_from_7p_mle(u(:,s2),F,...
            %                               'Algorithm','Default','Sigma',diag([Sigma Sigma Sigma Sigma]));
            
            X = eg_sampson_F_dist(u,F);

            %            [~,s] = orsa_objective_fn(X,[],[],[],cfg,1);
            s2 = sum(X.^2,1) < cfg.tsq;

%            a = eg_get_orientation(u(:,s),F);
%            s2 = false(1,size(s,2));
%            s2(s) = (a == mode(a));
%
            if (sum(s2) > 8)
                %                init.Sigma =
                %                sum(sum(X(:,s2).^2))/size(X,2)/size(X,1);
                init.Sigma = (4*cfg.sigma).^2;
                init.prior(1) = sum(s2)/numel(s2);
                init.prior(2) = 1-init.prior(1);
                nn = floor(init.prior(1)*numel(s2));
                init.Sigma = mad(reshape(X(:,s2),1,[]),1).^2;
                %                init.Sigma = ikose(reshape(X(:,s2),1,[]),ceil(nn/2),nn).^2;
                init.U = U;
                Sigma = init.Sigma;
                R = UGMMF.expectation(X,init);
            else
                R = [zeros(size(X,2),1) ones(size(X,2),1)];
                Sigma=[];                
            end
        end

        %% loggauss pdf
        function lp = loggausspdf(X, mu, Sigma)

            d = size(X,1);
            X = bsxfun(@minus,X,mu);

            [R, p] = chol(Sigma);    
            if p~=0, error('ERROR: Sigma is not symmetric'); end

            q = sum((R'\X).^2,1); % Mahalonobis distance
            c = d*log(2*pi) + 2*sum(log(diag(R))); % normalization constant

            lp = -(c+q)/2;
        end

        %% logsumexp
        function s = logsumexp(x, dim)

            if nargin == 1, 
                % Determine which dimension sum will use
                dim = find(size(x)~=1,1);
                if isempty(dim), dim = 1; end
            end

            y = max(x, [], dim);
            x = bsxfun(@minus, x, y);
            s = y + log(sum(exp(x),dim));

            i = find(~isfinite(s));
            if ~isempty(i), s(i) = y(i); end    

        end
              
    end
    
end %class