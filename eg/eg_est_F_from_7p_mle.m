function F = eg_est_F_from_7p_mle(u,F0,varargin)

p = inputParser;
p.addParamValue('Weights',ones(size(u,2),1));
p.addParamValue('Algorithm','Default');
p.addParamValue('Sigma',[]);
p.parse(varargin{:});

W = p.Results.Weights;
Sigma = p.Results.Sigma;

if ~isempty(Sigma)
    R = chol(Sigma);
else
    R = eye(4);
end

if strcmpi('bartoli',p.Results.Algorithm)
    F = go_bartoli(u,F0,W);
else
    F = go_overparam(u,F0,W,R);
end

function F = go_bartoli(u,F0,W)
    [U0,S,V0] = svd(F0);
    %s0 = [acos(S(1,1)) acos(S(2,2))];
    s0 = S(2,2)/S(1,1);

    unwrap = @(x) ...
             mtx_R_to_3x3(x(1:3))*U0* ...
             diag([1 s0+x(4) 0])* ...
             mtx_R_to_3x3(x(5:7))*V0';
    err_fn = @(x) reshape(bsxfun(@times,sqrt(W'),eg_sampson_F_dist(u,unwrap(x))),[],1);

    x0 = zeros(7,1);

    options = optimset('Display', 'Off', ...
                       'Diagnostics', 'Off');
    
    x = lsqnonlin(err_fn,x0,[],[],options);
    F = unwrap(x);

function F = go_overparam(u,F0,W,R)
    unwrap = @(x) mtx_make_skew_3x3(x(end-2:end))*reshape(x,3,4)*[eye(3); 0 0 0];
    err_fn = @(x) ...
             reshape(bsxfun(@times,sqrt(W'),R'\eg_sampson_F_dist(u,unwrap(x))),[],1);
    [P1,P2] = cam_get_2P_from_F(F0);

    x0 = P2(:);

    options = optimset('Display', 'Off', ...
                       'Diagnostics', 'Off');

    %x = lsqnonlin(@overparam_err_fn,x0,[],[],options,u,W,R);
    x = lsqnonlin(err_fn,x0,[],[],options);
    F = unwrap(x);

function err = overparam_err_fn(x,u,W,R)
    unwrap = @(x) mtx_make_skew_3x3(x(end-2:end))*reshape(x,3,4)*[eye(3); 0 0 0];
    err0 = reshape(bsxfun(@times,sqrt(W'),...
                          R'\eg_sampson_F_dist(u,unwrap(x))),[],1);
    err = tukey(err0);

function err = tukey(err0)
    aerr = abs(err0);
    c = 4.6851;
    s = aerr < c;
    err = zeros(size(aerr));
    err(s) = c^2/6*(1-(1-(err0(s)/c).^2).^3);
    err(~s) = c^2/6;

function err = huber(err0)
    aerr = abs(err0);
    k = 1.345;
    s = aerr < k;
    err = zeros(size(aerr));
    err(s) = aerr(s)/sqrt(2);
    err(~s) = sqrt(k*(aerr(~s)-k/2));


function R = mtx_R_to_3x3(r)
    q = norm(r); % angle of ration
    if (q == 0), 
        R = eye(3,3);
    else
        W = mtx_make_skew_3x3(r/q); 	
        R = (eye(3) + W*sin(q) + W^2*(1-cos(q)));
    end
