function v = ru_div_tform(u,T)
v = CAM.ru_div(u',T.tdata.cc,T.tdata.q)';
