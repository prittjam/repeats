function model_list = rt_est_3p(u,s,varargin)
Xw = u(4:7,s);

res = p3p_grunert(Xw,u(1:3,s));

model_list = cell(1,numel(res));

i = 1;
for r = res
    Xc = r{1};
    [R t] = XX2Rt_simple(Xw,Xc);
    model_list{i} = [R t];
    i = i+1;
end