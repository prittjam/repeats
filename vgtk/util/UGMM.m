%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%

classdef UGMM
    
    methods(Static)
        
        function [label, model, llh, R] = ugmm_em(X,maxiter,u,s)

        % Expectation-Maximization estimation of UGMM parameters.
        % This function learns the parameters of a Gaussian Mixture Model 
        % (UGMM) using a recursive Expectation-Maximization (EM) algorithm, starting 
        % from an initial estimation of the parameters.
        %
        %
        % Inputs -----------------------------------------------------------------
        %   X:    D x N array representing N datapoints of D dimensions.
        %   
        % Outputs ----------------------------------------------------------------
        %   o label:   array representing to one of the K UGMM components. values in
        %   arnge 1:K
        %   o model: {mu, Sigma, Prior}
        %     mu:      D x K array representing the centers of the K UGMM components.
        %     Sigma:   D x D x K array representing the covariance matrices of the 
        %              K UGMM components.
        %     Prior:   Prior probability of each of K classes
        %   o llh:     LogLikelihood on each iteration of algorithm


        if isempty(X)
            label = [];
            model = [];
            llh = [];
            return;
        end
        
        if nargin < 3
            maxiter = 500;
        end
        
        tol = 1e-6;        
        llh = -inf(1,maxiter);
        converged = false;
        t = 1;

%         fprintf('EM for Gaussian mixture: running ... \n');

U = init.U;

        %% initialization // E-step

        R = UGMM.initialization(X, init);
        [~, label(1,:)] = max(R,[],2);
        R = R(:, unique(label));

        %% algorithm

        while ~converged && t <= maxiter

            t = t + 1;
            %% M-step
            model = UGMM.maximization(X, R, U);

            %% E-step
            [R, llh(t)] = UGMM.expectation(X, model);
            %%
            [~, label(1,:)] = max(R,[],2);
            idx = unique(label);

            if size(R,2) ~= size(idx,2)
               R = R(:,idx); 
            else 
               converged = llh(t)-llh(t-1) < tol*abs(llh(t));
            end

        end

        llh = llh(2:t);
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

            for i = 1:k, logPxi(:,i) = UGMM.loggausspdf(X, model.mu(:,i), model.Sigma(:,:,i)); end

            logPxi = bsxfun(@plus, logPxi, log(model.prior));
            logPx = UGMM.logsumexp(logPxi, 2);
            
        end
    
    end
    
    methods(Static,Access=public)
        
        %% maximization step
        function model = maximization(X, R, U)

        [d, n] = size(X);
        k = size(R, 2)-1;

        s = sum(R,1);
        model.prior = s/n;

        mu = zeros(1,k);
        Sigma = zeros(d,d,k);

        for i = 1:k
            Xo = bsxfun(@minus,X,mu(:,i));
            Xo = bsxfun(@times,Xo,sqrt(R(:,i)'));
            Sigma(:,:,i) = Xo*Xo'/s(i);
            Sigma(:,:,i) = Sigma(:,:,i)+eye(d)*(1e-6); % added for numerical stability
        end

        model.mu = mu;
        model.Sigma = Sigma;
        model.U = U;
        
        end

        %% exapectation step
        function [P, llh] = expectation(X, model)

            mu = model.mu;
            Sigma = model.Sigma;
            prior = model.prior;
            U = model.U;

            n = size(X, 2);
            k = size(mu, 2);
            logPxi = zeros(n, k+1);

            for i = 1:k, logPxi(:,i) = UGMM.loggausspdf(X, mu(:,i), ...
                                                        Sigma(:,:,i)); end
            logPxi(:,k+1) = log(U);

            logPxi = bsxfun(@plus, logPxi, log(prior));
            logPx = UGMM.logsumexp(logPxi, 2);

            llh = sum(logPx)/n; % loglikelihood
            logPix = bsxfun(@minus,logPxi,logPx);

            P = exp(logPix);
        end
        
        %% loggauss pdf
        function lp = loggausspdf(X, mu, Sigma)

            d = size(X,1);
            X = bsxfun(@minus, X, mu);

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
        
        %% initialization
        function R = initialization(X, init)
        [d,n] = size(X);
        if isstruct(init)  % initialize with a model
            R  = UGMM.expectation(X,init);
        elseif length(init) == 1  % random initialization
            k = init;
            k = min(n,k);
            idx = randsample(n,k);
            m = X(:,idx);
            [~,label] = max(bsxfun(@minus,m'*X,sum(m.^2,1)'/2),[],1);
            while k ~= unique(label)
                idx = randsample(n,k);
                m = X(:,idx);
                [~,label] = max(bsxfun(@minus,m'*X,sum(m.^2,1)'/2),[],1);
            end
            R = full(sparse(1:n,label,1,n,k,n));
        elseif size(init,1) == 1 && size(init,2) == n  % initialize with labels
            label = init;
            k = max(label);
            R = full(sparse(1:n,label,1,n,k,n));
        elseif size(init,1) == d  %initialize with only centers
            k = size(init,2);
            m = init;
            [~,label] = max(bsxfun(@minus,m'*X,sum(m.^2,1)'/2),[],1);
            R = full(sparse(1:n,label,1,n,k,n));
        else
            error('ERROR: init is not valid.');
        end

        end
        
        
    end
    
end %class