function ransac = make_ransac(G_app,motion_model)
sampler = GrSampler(G_app);
eval = GrEval('motion_model',motion_model);
model = RANSAC.WRAP.laf1x3_to_HaHp();
lo = GrLo();
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);
