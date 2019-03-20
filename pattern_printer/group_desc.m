%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [x,G] = group_desc(dr)
G = DR.group_desc_app(dr,'desc_linkage', 'single', ...
                      'desc_cutoff', 160);
%Gr = DR.group_reflections(dr);

%Gr_tmp = Gr;
%Gr_tmp(find(uGr_tmp == 0)) = -1;
%
%Gsamp = findgroups(Gapp.*Gr_tmp);
%freq = hist(Gsamp,1:max(Gsamp));
%bad_labels = find(freq < 2);
%[~,ind] = ismember(bad_labels,Gsamp);
%Gsamp(ind) = nan;
%Gsamp = findgroups(Gsamp);

x = [dr(:).u];
