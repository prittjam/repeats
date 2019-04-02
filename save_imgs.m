function [] = save_imgs(results_path,img_path,uimg,rimg,masked_sc_img,rd_div_line_img)

if ~exist(results_path, 'dir')
    mkdir(results_path);
end
    
[~,img_name] = fileparts(img_path);

if ~isempty(uimg)
    ud_file_path = fullfile(results_path,[img_name '_ud.jpg']);
    imwrite(uimg,ud_file_path);
end

if ~isempty(rimg)
    rect_file_path = fullfile(results_path,[img_name '_rect.jpg']);
    imwrite(rimg,rect_file_path);
end 

if ~isempty(masked_sc_img)
    masked_sc_file_path = fullfile(results_path,[img_name '_masked_cs.jpg']);
    imwrite(masked_sc_img,masked_sc_file_path);    
end

if ~isempty(rd_div_line_img)
    rd_div_line_img_path = fullfile(results_path,[img_name '_rd_div_line.jpg']);
    imwrite(rd_div_line_img,rd_div_line_img_path);    
end