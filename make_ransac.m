function ransac = make_ransac(dr,corresp,cc,motion_model)
switch motion_model
  case 't'
    solver = RANSAC.WRAP.laf2x2_to_HaHp();
  case 'Rt'
    solver = RANSAC.WRAP.laf2x2_to_HaHp();
end

sampler = GrSampler(dr,corresp,2);
eval = GrEval2();
lo = GrLo(cc,'motion_model',motion_model);
ransac = RANSAC.Ransac(solver,sampler,eval,'lo',lo);
