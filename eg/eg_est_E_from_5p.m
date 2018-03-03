function model_list = eg_est_E_from_5p_gb(u,s,varargin)

if ~exist('p5gb','file')
  error('Cannot find five-point estimator. Probably PATH is not set.');
end

Es = p5gb(u(1:3,s), ...
          u(4:6,s));
model_list = cell(1,size(Es,2));

for i = 1:size(Es,2)
  model_list{ i } = reshape(Es(:,i),3,3)';
end