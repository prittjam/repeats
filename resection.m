function M = resection(u,G,Hinf,motion_model)
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
          [Rt(:).t]',[Rt(:).a11]',motion_model_list, ...
          [Rt(:).inverted]', Gu', ...
          'VariableNames',{'i','j','theta','tij','a11',...
                    'MotionModel','inverted','G_u'});

function [rt,ii,jj,is_inverted] = laf2xNxN_to_RtxNxN(u,varargin)
cfg.do_inversion = false;
cfg.is_reflected = [];
cfg.motion_model = 'laf2xN_to_RtxN';

[cfg,leftover] = cmp_argparse(cfg,varargin{:});

N = size(u,2);
[ii,jj] = itril([N N],-1);

rt = feval(cfg.motion_model,[u(:,ii);u(:,jj)]);
is_inverted = false(1,N);

if cfg.do_inversion
    [rt,is_inverted] = unique_ro(rt);
    [jj(is_inverted),ii(is_inverted)] = deal(ii(is_inverted), ...
                                             jj(is_inverted));
end

function Rt = laf2xNxN_to_RtxNxN_wrapper(u,ind,motion_model)
[rt,ii,jj,is_inverted] = ...
    laf2xNxN_to_RtxNxN(u,'do_inversion',true, ...
                       'motion_model', motion_model);
I = mat2cell(ind(ii),1,ones(1,numel(ii)));
J = mat2cell(ind(jj),1,ones(1,numel(jj)));
inverted = mat2cell(is_inverted,1,ones(1,numel(is_inverted)));

theta = rt(1,:);
t = rt(2:3,:);
a11 = rt(4,:);
Rt = struct('theta', mat2cell(rt(1,:),1,ones(1,size(rt,2))), ...
            't', mat2cell(rt(2:3,:),2,ones(1,size(rt,2))), ...
            'a11', mat2cell(rt(4,:),1,ones(1,size(rt,2))));
[Rt(:).i] = deal(I{:});
[Rt(:).j] = deal(J{:});
[Rt(:).inverted] = deal(inverted{:});
