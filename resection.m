function M = resection(u,Hinf,G,motion_model)
v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);

[g_rt,Gu] = cmp_splitapply(@(v,ind,G) ...
                           deal( { laf2xNxN_to_RtxNxN_wrapper(v,ind,motion_model) }, ...
                                 { repmat(G(1),1,nchoosek(numel(G),2)) }), ...
                           v,1:size(v,2),G,G);
Rt = [g_rt{:}];
Gu = [Gu{:}];

N = numel(Rt);
switch motion_model
  case 'HG.laf2xN_to_txN'
    motion_model_list = categorical(ones(N,1),[1 2], ...
                             {'HG.laf2xN_to_txN','HG.laf2xN_to_RtxN'});
  case 'HG.laf2xN_to_RtxN'
    motion_model_list = categorical(2*ones(N,1),[1 2], ...
                                    {'HG.laf2xN_to_txN','HG.laf2xN_to_RtxN'});
end

M = table([Rt(:).i]',[Rt(:).j]',[Rt(:).theta]', ...
          [Rt(:).t]',motion_model_list, [Rt(:).reflected]', Gu', ...
          'VariableNames',{'i','j','theta','tij',...
                    'MotionModel','reflected','G_u'});

function [Rt,reflect] = laf2xNxN_to_RtxNxN_wrapper(u,ind,motion_model)
[rt,ii,jj,is_reflected] = ...
    HG.laf2xNxN_to_RtxNxN(u,'do_reflection',true, ...
                          'motion_model', motion_model);
I = mat2cell(ind(ii),1,ones(1,numel(ii)));
J = mat2cell(ind(jj),1,ones(1,numel(jj)));
reflected = mat2cell(is_reflected,1,ones(1,numel(is_reflected)));

theta = rt(1,:);
t = rt(2:3,:);
Rt = struct('theta',mat2cell(rt(1,:),1,ones(1,size(rt,2))), ...
            't',mat2cell(rt(2:3,:),2,ones(1,size(rt,2))));
[Rt(:).i] = deal(I{:});
[Rt(:).j] = deal(J{:});
[Rt(:).reflected] = deal(reflected{:});
