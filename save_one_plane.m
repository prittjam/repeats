%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [] = ...
    save_one_plane(solver_name,name, ...
                   rimg,uimg,rect_rd_div_scale_img,rect_dscale_img,varargin)

cfg.target_dir = 
                             
imwrite(rimg, ...
        [target_dir name '_' name_list{k2} '_rect.jpg']);
imwrite(uimg, ...
        [target_dir name '_' name_list{k2} '_ud.jpg']);
imwrite(rect_rd_div_scale_img, ...
        [target_dir name '_' name_list{k2} '_rect_dscale.jpg']);
imwrite(rect_dscale_img, ...
        [target_dir name '_' name_list{k2} '_rect_rd_div_dscale.jpg']);