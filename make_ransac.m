function ransac = make_ransac(dr,corresp,cc,motion_model)
sampler = ElationSampler(dr,corresp,2);

switch motion_model
  case 't'
    model = RANSAC.WRAP.laf2x2_to_HaHp();
  case 'Rt'
    model = RANSAC.WRAP.laf2x2_to_HaHp();
end

%eval = GrEval('motion_model',motion_model);
eval = GrEval2();
lo = GrLo([dr(:).Gapp],cc, ...
          'motion_model',motion_model);
ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);
