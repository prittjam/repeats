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
          [Rt(:).reflected]', ...
          'VariableNames',{'i','j','theta','tij',...
                    'MotionModel','reflected'});

function [Rt,reflect] = calc_pwise_xforms(u,ind,motion_model)
N = size(u,2);
[ii,jj] = itril([N N],-1);
Rt = feval(motion_model,[u(:,ii);u(:,jj)]);

t = [Rt(:).t];
theta = [Rt(:).theta];

reflect = false(1,numel(theta));
reflect = t(1,:) < 0;
theta(reflect) = -1*theta(reflect);
t(:,reflect) = PT.apply_rigid_xforms(-1*t(:,reflect), ...
                                     theta(reflect), ...
                                     zeros(2,sum(reflect)));
[jj(reflect),ii(reflect)] = deal(ii(reflect),jj(reflect));

Rt = struct('theta',mat2cell(theta,1,ones(1,numel(theta))), ...
            't',mat2cell(t,2,ones(1,numel(theta))), ...
            'i',mat2cell(ind(ii),1,ones(1,numel(theta))), ...
            'j',mat2cell(ind(jj),1,ones(1,numel(theta))), ...
            'reflected',mat2cell(reflect,1,ones(1,numel(theta))));
