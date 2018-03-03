function s3 = laf_clip_by_bb(u,s,x);
v = laf_renormI(u);
abc = [1 2 4 5 7 8];

w = reshape(v(abc,:),2,[]);

s2 = [ reshape(w(1,:) > x(1),3,[]); ...
       reshape(w(1,:) < x(2),3,[]); ...
       reshape(w(2,:) > x(3),3,[]); ...
       reshape(w(2,:) < x(4),3,[]) ];

s3 = all([s;s2]);