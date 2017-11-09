function [x,Gsamp,Gapp] = group_desc(dr)
Gapp = DR.group_desc_app(dr,'desc_linkage', 'single', ...
                         'desc_cutoff', 160);
Gr = DR.group_reflections(dr);
Gr_tmp = Gr;
Gr_tmp(find(Gr_tmp == 0)) = -1;

Gsamp = findgroups(Gapp.*Gr_tmp);
freq = hist(Gsamp,1:max(Gsamp));
bad_labels = find(freq < 2);
[~,ind] = ismember(bad_labels,Gsamp);
Gsamp(ind) = nan;
Gsamp = findgroups(Gsamp);

keyboard;

x = [dr(:).u];
ind = find(Gsamp == 45);
figure;
LAF.draw(gca,x(:,ind([1 3])))

tst = 

LAF.is_right_handed(x(:,ind))




function [] = group_rotations(x)
A = LAF.pt3x3_to_A(x(:,ind(1:3)));
zeros(1,numel(A));
for k = 1:numel(A)
    q = qr(A{k});
     = q(1,1)
end
