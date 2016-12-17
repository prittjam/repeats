function v = rd_tform(u,T)
v = CAM.rd(u',T.tdata.cc,T.tdata.q)';
