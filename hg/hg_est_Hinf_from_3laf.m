function [H,s,v_laf] = hg_est_Hinf_from_3laf(u_laf,s)
if max(sum(s,2)) < 3
    error('At least 3 LAFs are needed');
end

k = 1;
H = eye(3,3);
sc0 = inf;
v_laf = u_laf;

while true
    valid_rows = find(sum(s > 0,2) > 1);
    k = 1;
    for j = valid_rows
        ind = find(s(j,:));
        aX{k} = (v_laf(1:2,ind)+v_laf(4:5,ind)+v_laf(7:8,ind))/3;
        t1 = abs(1./laf_get_scale_from_3p(v_laf(:,ind)));
        arsc{k} = t1;
        k = k+1;
    end
    [Hi,sc] = scale2H(aX{1},arsc{1});
    sc = abs(sc);
    if ~isreal(Hi)
        break; % could throw exception
    end
    Hinf = hg_make_Hinf_from_linf(Hi(3,:));
    H = Hinf*H;
    v_laf = laf_renormI(blkdiag(H,H,H)*u_laf);
    A = cell2mat(hg_est_A_from_1laf([v_laf(:,ind);u_laf(:,ind)], ...
                                    true(1,numel(ind))));
    H = A*H;
    v_laf = laf_renormI(blkdiag(H,H,H)*u_laf);

    if (sc == inf)
        kkk = 3;
    end

    if abs((sc0-sc)/sc) < 1e-4 | k > 10
        break;
    end

    sc0 = sc;
    k = k+1;
    break;
end 

function [H, alpha] = scale2H(X, rsc)

X = X(1:2,:);
rsc = nthroot(rsc,3);

if any(imag(rsc) > 0)
fprintf('!');
%  keyboard
end

 tx = mean(X(1,:));
 ty = mean(X(2,:));
 X(1,:) = X(1,:) - tx;
 X(2,:) = X(2,:) - ty;
 dsc = max(abs(X(:)));

 X = X / dsc;

A = eye(3);
A([1,2],3) = -[tx ty] / dsc;
A(1,1) = 1 / dsc;
A(2,2) = 1 / dsc;

sc_norm = min(abs(rsc));
%Z = [rsc .* X(1,:); rsc .* X(2,:); -ones(1, size(X,2))]';
Z = [X(1,:); X(2,:); -sc_norm./rsc(:)']';
%
%[u d v] = svd(Z);
%hs = v(:,end);

%hs = pinv(Z) * -rsc(:);

hs = pinv(Z) * -ones(size(X,2),1);

%keyboard

H = eye(3);

H(3,1) = hs(1);
H(3,2) = hs(2);

H = H * A;

alpha = hs(3) * sc_norm / nthroot(det(A),3);


function [H,s] = scale2H_multi(aX, arsc)

% scale2H_multi
if ~iscell(aX)
  aX = {aX};
  arsc = {arsc};
end

ALLX = [aX{:}];
ALLX = ALLX(1:2,:);

 tx = mean(ALLX(1,:));
 ty = mean(ALLX(2,:));
 ALLX(1,:) = ALLX(1,:) - tx;
 ALLX(2,:) = ALLX(2,:) - ty;
 dsc = max(abs(ALLX(:)));

A = eye(3);
A([1,2],3) = -[tx ty] / dsc;
A(1,1) = 1 / dsc;
A(2,2) = 1 / dsc;


len = length(aX);
Z = [];
R = [];

for i = 1 : len
  rsc = nthroot(arsc{i}*dsc^2,3);
  X = aX{i};

  X(1,:) = (X(1,:) - tx) / dsc;
  X(2,:) = (X(2,:) - ty) / dsc;

  z = [rsc .* X(1,:); rsc .* X(2,:)];
  z(len+2, :) = 0;
  z(i+2,:) = -ones(1, size(X,2));

  Z = [Z; z'];
  R = [R; rsc(:)];
end


hs = pinv(Z) * -R;

H = eye(3);

H(3,1) = hs(1);
H(3,2) = hs(2);

H = H * A;
s = hs(3)^3;
%keyboard
