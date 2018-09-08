%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
% Copyright (c) 2017 James Pritts
% 
function [sifts,xsifts,drid] = make_sifts(labels,ctg,varargin)
cfg.desc_xform = @double;
cfg.sift_sigma = 25;

[cfg,~] = cmp_argparse(cfg,varargin{:});

elabels = find(ctg.outlier_ctgs);
ulabels = setdiff(labels,elabels);
jj = find(labels < elabels);
m = numel(ulabels);
n = numel(labels);

c = 255*rand(128,m);
%c = 255*repmat(rand(128,1),1,m);

rep = [];
JJ = [];
sifts0 = [];
cv = diag(ones(1,128)*cfg.sift_sigma^2);

sifts = round(255*rand(128,n)); 
drid = floor(m*rand(1,n))+1;

for k = 1:numel(ulabels)
    jj2 = find(labels == ulabels(k));
    if cfg.sift_sigma > 0
        sifts(:,jj2) = mvnrnd(c(:,k),cv,numel(jj2))';
    else
        sifts(:,jj2) = repmat(c(:,k),[1 numel(jj2)]);
    end
        drid(:,jj2) = ones(1,numel(jj2))*k;
    %    drid(:,jj) = 2*ceil(rand(1));
end

sifts(find(sifts<0)) = 0;
sifts(find(sifts>255)) = 255;

xsifts = feval(cfg.desc_xform,sifts);
