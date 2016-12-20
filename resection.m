function M = resection(u,G,motion_model)
g_rt = cmp_splitapply(@(v,ind) { calc_pwise_xforms(v,ind,motion_model) }, ...
                      u,1:size(u,2),G);
Rt = [g_rt{:}];
N = numel(Rt);

switch motion_model
  case 'laf2xN_to_txN'
    motion_model_list = categorical(ones(N,1),[1 2], ...
                             {'laf2xN_to_txN','laf2xN_to_RtxN'});
  case 'laf2xN_to_RtxN'
    motion_model_list = categorical(2*ones(N,1),[1 2], ...
                                    {'laf2xN_to_txN','laf2xN_to_RtxN'});
end

M = table([Rt(:).i]',[Rt(:).j]',[Rt(:).theta]',[Rt(:).t]',motion_model_list, ...
            'VariableNames',{'i','j','theta','t','MotionModel'});

function Rt = calc_pwise_xforms(u,ind,est_xform)
N = size(u,2);
[ii,jj] = itril([N N],-1);
Rt = feval(est_xform,[u(:,ii);u(:,jj)]);
t = [Rt(:).t];
theta = [Rt(:).theta];
reflect = t(1,:) < 0;
t(:,reflect) = -1*t(:,reflect);
[jj(reflect),ii(reflect)] = deal(ii(reflect),jj(reflect));
Rt = struct('theta',mat2cell(theta,1,ones(1,numel(theta))), ...
            't',mat2cell(t,2,ones(1,numel(theta))), ...
            'i',mat2cell(ind(ii),1,ones(1,numel(theta))), ...
            'j',mat2cell(ind(jj),1,ones(1,numel(theta))));
