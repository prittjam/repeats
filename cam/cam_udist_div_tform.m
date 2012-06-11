function u = cam_udist_div_tform(u,T)
u = cam_udist_div(u,T.cc,T.q);