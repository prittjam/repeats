function G = segment_motions(u,Hinf,ii,jj,Rt,xform_type)
Hinv = inv(Hinf);
v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);

N = numel(ii);
[aa,bb] = meshgrid(1:N,1:N);
v_mu = v(4:6,ii(aa(:)));
Rt = Rt(bb,:)';

switch (unique(xform_type))
  case 'laf2xN_to_txN'
    x = PT.to_euclidean(Hinv*(PT.translate(v_mu,Rt)));
  case 'laf2xN_to_RtxN'
    x = PT.to_euclidean(Hinv*(PT.apply_rigid_xform(v_mu,Rt(1,:),Rt(2:3,:))));    
end
    
y = u(4:5,jj(aa(:)));
d = sqrt(sum((y-x).^2));
ind = sub2ind([N N],aa,bb);

D = inf(N,N);
D(ind) = d;
dlin = reshape(D(itril(size(D),-1)),1,[]);
Z = linkage(dlin,'single');
G = cluster(Z,'cutoff',5,'criterion','distance');
freq = hist(G,1:max(G));
[~,idxb] = ismember(find(freq == 1),G);
G(idxb) = nan;
G = findgroups(G);
