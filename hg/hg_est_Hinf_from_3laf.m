function [H,s,v_laf] = hg_est_Hinf_from_3laf(u_laf,s)
if max(sum(s,2)) < 3
    error('At least 3 LAFs are needed');
end

k = 1;
H = eye(3,3);
s0 = inf;

while true
    v_laf = laf_renormI(blkdiag(H,H,H)*u_laf);
    valid_rows = find(sum(s > 0,2) > 1);
    k = 1;
    for j = valid_rows
        ind = find(s(j,:));
        aX{k} = (v_laf(1:2,ind)+v_laf(4:5,ind)+v_laf(7:8,ind))/3;
        t1 = 1./laf_get_scale_from_3p(v_laf(:,ind));
        arsc{k} = t1;
        k = k+1;
    end
    [Hi,s] = scale2H_multi(aX,arsc);
    H = diag([sqrt(s) sqrt(s) 1])*Hi*H;
    if ~isreal(H)
        error('Homography has complex entries');
    end

    if abs((s0-s)/s) < 1e-4 | s < 1e-6 | k > 10
        break;
    end

    s0 = s;
    k = k+1;
end 


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

  rsc = (arsc{i}*dsc^2).^(1/3);
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
