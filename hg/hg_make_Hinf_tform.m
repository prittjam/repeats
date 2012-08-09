function T = hg_make_Hinf_tform(H,T2);
if nargin < 2
    T = maketform('projective',H');
else
    T1 = maketform('projective',H');
    T = maketform('composite',T1,T2);
end