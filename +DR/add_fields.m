function fdr = add_fields(fdr)
area = LAF.get_scale([fdr(:).u]);

m = 1./nthroot(area,3);
sct = mat2cell(m,1,ones(1,numel(fdr)));
[fdr(:).sc] = sct{:};

tmp = [fdr(:).u];
m = [(tmp(1:2,:)+tmp(4:5,:)+tmp(7:8,:))/3];
mut = mat2cell(m,2,ones(1,numel(fdr)));
[fdr(:).mu] = mut{:};

mser_drid = [2048 2049];
mser_ind = find(ismember([fdr(:).drid],mser_drid));
is_mser = zeros(1,numel(fdr));
is_mser(mser_ind) = ones(1,numel(mser_ind));
msers = mat2cell(is_mser,1,ones(1,numel(fdr)));
[fdr(:).is_mser] = msers{:};
m = feval(@SIFT.sift_calc_rootSIFT, ...
                  double([fdr.desc]));
mt = mat2cell(m,128,ones(1,numel(fdr)));
[fdr(:).xdesc] = mt{:};

