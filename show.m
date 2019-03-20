img_name = 'cropped_dartboard';
%img_name = 'pattern1b'
load(['output/' img_name '.mat']);
%figure;
%subplot(1,3,1);
%imshow(img.data);
%PT.draw_groups(gca,meas.x,meas.G);
%
%subplot(1,3,2);
%imshow(img.data);
%PT.draw_groups(gca,meas.x,model_list(1).Gs');
%
%subplot(1,3,3);
%imshow(img.data);
%PT.draw_groups(gca,meas.x,model_list(1).Gm');
% 
k=1;
ind = find(~isnan(model_list(k).Gm));
v = reshape(meas.x(:,unique(lo_res_list.info.cspond(lo_res_list.info.inl))),3,[]);

sides = side(cspond(:,d2inl));
[~,best_side] = max(hist(sides,[1,2]));
side_inl =  find(all(sides == best_side));
inl = d2inl(side_inl);

cc = model_list(k).cc;
q = model_list(k).q;
output_one_plane(img.data,model_list(k).Hr,cc,q,v);