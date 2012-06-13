function u = cam_udist_div_tform(u,T)
v = cam_udist_div(u',T.tdata.cc,T.tdata.q);
u = v';