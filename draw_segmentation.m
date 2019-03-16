%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw_segmentation(u,M,img)
uG = unique(M.Gm);
cmap_dc = distinguishable_colors(numel(uG));
colors = zeros(numel(M.Gm),3);
colors(M.Gm>0,:) = cmap_dc(M.Gm(M.Gm>0),:);
cmp_splitapply(@(i,j,color) draw_one_group(u(:,i),u(:,j),color(1,:),img),...
               M.i,M.j,colors,M.Gm);

function [] = draw_one_group(u,v,color,img)
figure;
imshow(img);
PT.draw(gca,u,'Color',color,'LineWidth',3);
PT.draw(gca,v,'Color',color,'LineWidth',3,'LineStyle','--');
