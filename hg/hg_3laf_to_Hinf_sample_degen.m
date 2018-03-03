function is_degen = hg_3laf_to_Hinf_sample_degen(u)
ind = [1 2 3];
du = u(1:2,[1 2 3])-u(1:2,[2 3 1]);
du = bsxfun(@rdivide,du(1:2,:),sqrt(sum(du(1:2,:).^2,1)));
du2 = du(:,[2 3 1]);
angle = acos(dot(du,du2));
is_degen = any(angle < 15*pi/180);