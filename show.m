%img_name = 'cropped_dartboard';
%img_name = 'pattern1b'
%img_name = 'pavement'
img_name = 'raw'
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
v = reshape(meas.x(:,unique(res_list.info.cspond(:,res_list.cs))),3,[]);
cc = model_list(k).cc;
q = model_list(k).q;

inlx = unique(res_list.info.cspond(:,res_list.cs));

output_one_plane(img.data,model_list(k).Hr,cc,q,v);