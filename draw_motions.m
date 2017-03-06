function [] = draw_motions(res,img,varargin)
uG_ij = reshape(unique(res.u_corr.G_ij),1,[]);
for k = uG_ij
    resk = res;
    ind = find(res.u_corr.G_ij == k);
    resk.u_corr = resk.u_corr(ind,:); 
    figure;
    imshow(img);
    draw_reconstruction(gca,resk,varargin{:});
end
