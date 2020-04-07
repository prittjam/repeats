function X = make_outliers(N,w,h)
t = 0.9*rand(2,N)-0.45;
%x = LAF.translate(x,t);
A = Rt.params_to_mtx([zeros(1,N);t;ones(1,N)]);
M = [[w 0; 0 h] [0 0]';0 0 1];
X = PT.mtimesx(multiprod(M,A),LAF.make_random(N));  