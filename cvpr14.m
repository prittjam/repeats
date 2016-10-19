function [M,desc_groups,res,stats] = cvpr14(dr,varargin)
desc_groups = group_desc(dr);

sampler = VlSampler(desc_groups);
eval = VlEval();
model = RANSAC.laf3x1_to_Hinf_model();
lo = Lo();

ransac = RANSAC.Ransac(model,sampler,eval,'lo',lo);
[M,res,stats] = ransac.fit(dr,desc_groups);
G = select_models(dr,desc_groups,M,res);