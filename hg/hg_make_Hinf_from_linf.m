function H = hg_make_Hinf_from_linf(l_inf)

% takse line at infinity l_inf
% designs camera rotation H
% so that the l_inf goes to imfinity

if abs(l_inf(3)) > eps
  l_inf = l_inf / l_inf(3);
end

H(3,:) = l_inf(:)' / norm(l_inf);
H(2,:) = [0, l_inf(3), -l_inf(2)];
%s = sign(H(2,2) * H(2,3));
%if s == 0
%  s = sign(H(2,2) + H(2,3));
%end
H(2,:) = H(2,:) / norm(H(2,:));
H(1,:) = cross(H(2,:), H(3,:));
