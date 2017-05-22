function ransac = make_ransac(G_app,motion_model)
sampler = GrSampler(G_app);

switch motion_model
  case 't'
    model = RANSAC.WRAP.laf2x2_to_HaHp();
  case 'Rt'
    model = RANSAC.WRAP.laf2x2_to_HaHp();
end

eval = GrEval('motion_model',motion_model);
lo = GrLo(G_app,'motion_model',motion_model);
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);
