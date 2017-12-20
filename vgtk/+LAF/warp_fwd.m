function v = warp_fwd(u,T)
[x,y] = LAF.pt3x3_to_xy(u);
[tx,ty] = transformPointsForward(T,x,y);
v = LAF.xy_to_p3x3(tx,ty);