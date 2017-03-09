function G = cs_to_inlying_labels(labeling,cs,IJ)
if nargin < 3
    IJ = cmp_splitapply(@(g) { GrLo.itril_wrap(g) }, ...
                        1:numel(labeling),labeling);
    IJ = [ IJ{:} ] ;
end

inl = all(bsxfun(@times,cs,IJ));
inl_labels = unique(reshape(IJ(:,inl),1,[]));
G = nan(1,numel(labeling));
G(inl_labels) = labeling(inl_labels);
G = findgroups(G);

function IJ = itril_wrap(g)
N = numel(g);
[ii,jj] = itril([N N],-1);
IJ = [g(ii);g(jj)];
