function G = segment_motions(u,Hinf,ii,jj,Rt)
Hinv = inv(Hinf);
Rt = Rt';
v = LAF.renormI(blkdiag(Hinf,Hinf,Hinf)*u);
v_mu = v(4:6,:);

N = numel(ii);
[aa,bb] = meshgrid(1:N,1:N);
rt = PT.to_homogeneous(Rt);
x = PT.to_euclidean(Hinv*(PT.translate(v_mu(:,ii(aa(:))),Rt(:,bb(:)))));
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
