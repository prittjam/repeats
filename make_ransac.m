function ransac = make_ransac(G_app,motion_model)
sampler = GrSampler(G_app);
eval = GrEval('motion_model',motion_model);
model = RANSAC.WRAP.laf2x2_to_HaHp();
lo = GrLo(G_app);
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);
