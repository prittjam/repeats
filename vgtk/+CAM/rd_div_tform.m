function v = rd_div_tform(u,T)
v = CAM.rd_div(u',T.tdata.cc,T.tdata.q)';
