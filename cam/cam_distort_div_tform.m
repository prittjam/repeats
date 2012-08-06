function v = cam_dist_div_tform(u,T)
v = cam_dist_div(u',T.tdata.cc,T.tdata.qd)';