%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = draw_segmentation(u,M,img)
uG = unique(M.G_rt);
cmap_dc = distinguishable_colors(numel(uG));
colors = zeros(numel(M.G_rt),3);
colors(M.G_rt>0,:) = cmap_dc(M.G_rt(M.G_rt>0),:);
cmp_splitapply(@(i,j,color) draw_one_group(u(:,i),u(:,j),color(1,:),img),...
               M.i,M.j,colors,M.G_rt);

function [] = draw_one_group(u,v,color,img)
figure;
imshow(img);
LAF.draw(gca,u,'Color',color,'LineWidth',3);
LAF.draw(gca,v,'Color',color,'LineWidth',3,'LineStyle','--');
