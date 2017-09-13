function [xform_list,motion_model_list] = resection(u,v,G,motion_model)
switch motion_model
  case 't'
    motion_solver = 'HG.laf2xN_to_txN';    
  case 'Rt'
    motion_solver = 'HG.laf2xN_to_RtxN';
end

xform_list = ...
    cmp_splitapply(@(v,ind) ...
                   deal( { laf2xNxN_to_RtxNxN(v,ind,motion_solver,true) }), ...
                   v,1:size(v,2),G);
xform_list = [xform_list{:}];
N = numel(xform_list);

switch motion_model
  case 't'
    motion_model_list = categorical(ones(N,1),[1 2],{'t','Rt'});
  case 'Rt'
    motion_model_list = categorical(2*ones(N,1),[1 2],{'t','Rt'});
end

function xform_list = laf2xNxN_to_RtxNxN(x,ind,motion_solver,do_inversion)
N = size(x,2);
[ii,jj] = itril([N N],-1);

rt = feval(motion_solver,[x(:,ii);x(:,jj)]);
is_inverted = false(1,N);

if do_inversion
    [rt,is_inverted] = unique_ro(rt);
    [jj(is_inverted),ii(is_inverted)] = ...
        deal(ii(is_inverted),jj(is_inverted));
end

xform_list = struct('Rt',mat2cell(rt,4,ones(1,size(rt,2))), ...
                    'i', mat2cell(ind(ii),1,ones(1,numel(ii))), ...
                    'j', mat2cell(ind(jj),1,ones(1,numel(jj))));
