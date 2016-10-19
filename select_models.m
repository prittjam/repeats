function G = select_models(dr,desc_groups,H,res)
u = LAF.renormI(blkdiag(H,H,H)*[dr(:).u]);

est_R = true;
if est_R
    est_xform = @laf2xN_to_RtxN;
else
    est_xform = @laf2XN_to_txN;
end

T = cmp_splitapply(@(x) { deal(calc_pwise(x,est_xform)) }, ...
                        u,findgroups(desc_groups.*res.cs));            
Rt = [T{:}];
Rt(1,:) = abs(Rt(1,:));

c = cos(Rt(1,:));
s = sin(Rt(1,:));

v = [ c;s;-s;c ]+repmat(Rt(2:3,:),2,1);
Z = linkage(v','single');
G = cluster(Z,'cutoff', 3.0,'criterion','distance');
freq = hist(G,1:max(G));
[~,idxb] = ismember(find(freq == 1),G);
G(idxb) = nan;
G = findgroups(G);
freq = hist(G,1:max(G));
[max_freq,max_ind] = max(freq);
keyboard;
if max_freq > 1
    idx = find(G==max_ind);
end


function Rt = calc_pwise(u,f)
M = size(u,2);
[ii,jj] = find(tril(ones(M,M),-1));
Rt = f([u(:,ii);u(:,jj)]);