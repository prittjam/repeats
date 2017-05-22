function M = resection(u,G,model,motion_model)
Hinf = model.Hinf;
v = LAF.ru_div(LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u),model.cc,model.q);

switch motion_model
  case 't'
    motion_solver = 'HG.laf2xN_to_txN';    
  case 'Rt'
    motion_solver = 'HG.laf2xN_to_RtxN';
end

[g_rt,Gu] = cmp_splitapply(@(v,ind,G) ...
                           deal( { laf2xNxN_to_RtxNxN_wrapper(v,ind,motion_solver) }, ...
                                 { repmat(G(1),1,nchoosek(numel(G),2)) }), ...
                           v,1:size(v,2),G,G);
Rt = [g_rt{:}];
Gu = [Gu{:}];

N = numel(Rt);
switch motion_model
  case 't'
    motion_model_list = categorical(ones(N,1),[1 2],{'t','Rt'});
  case 'Rt'
    motion_model_list = categorical(2*ones(N,1),[1 2],{'t','Rt'});
end

M = table([Rt(:).i]',[Rt(:).j]',[Rt(:).theta]', ...
          [Rt(:).t]',[Rt(:).a11]',motion_model_list, ...
          [Rt(:).inverted]', Gu', ...
          'VariableNames',{'i','j','theta','tij','a11',...
                    'MotionModel','inverted','G_u'});

function [rt,ii,jj,is_inverted] = laf2xNxN_to_RtxNxN(u,motion_solver,do_inversion)
N = size(u,2);
[ii,jj] = itril([N N],-1);

rt = feval(motion_solver,[u(:,ii);u(:,jj)]);
is_inverted = false(1,N);

if do_inversion
    [rt,is_inverted] = unique_ro(rt);
    [jj(is_inverted),ii(is_inverted)] = ...
        deal(ii(is_inverted),jj(is_inverted));
end

function Rt = laf2xNxN_to_RtxNxN_wrapper(u,ind,motion_solver)
[rt,ii,jj,is_inverted] = laf2xNxN_to_RtxNxN(u,motion_solver,true);
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
