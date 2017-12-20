function K = cam_make_K(f,cc,alpha_c,px_sz);
%  make calibration matrix
K = zeros(3,3);
K(1,1) = f/px_sz(1);
K(2,2) = f/px_sz(2);
K(1,2) = -f*cos(pi/2-alpha_c)/px_sz(1)/sin(pi/2-alpha_c);
K(2,2) = f/px_sz(2)/sin(pi/2-alpha_c);
K(:,end) = [cc(1) cc(2) 1]';