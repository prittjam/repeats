function v = make_rd_tform(u,T)
v = cam_distort_div(u',T.tdata.cc,T.tdata.q)';
