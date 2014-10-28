function v = cam_distort_div_tform(u,T)
v = cam_distort_div(u',T.tdata.cc,T.tdata.q)';