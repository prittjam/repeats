function output_all_planes(x,img,model_list)
for k = 1:numel(model_list)
    ind = find(~isnan(model_list(1).Gs));
    v = reshape(x(:,ind),3,[]);
    H = model_list(1).A;
    H(3,:) = transpose(model_list(1).l);
    cc = model_list(1).cc;
    q = model_list(1).q;
    output_one_plane(img.data,H,cc,q,v);
end