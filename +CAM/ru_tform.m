function v = cam_undistort_div_tform(u,T)
v = cam_undistort_div(u',T.tdata.cc,T.tdata.q)';