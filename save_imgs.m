function [] = save_imgs(results_path,img_path,uimg,rimg,sc_img,masked_sc_img);
if ~exist(results_path, 'dir')
    mkdir(results_path);
end
    
[~,img_name] = fileparts(img_path);

ud_file_path = fullfile(results_path,[img_name '_ud.jpg']);
imwrite(uimg,ud_file_path);

rect_file_path = fullfile(results_path,[img_name '_rect.jpg']);
imwrite(rimg,rect_file_path);

sc_file_path = fullfile(results_path,[img_name '_cs.jpg']);
imwrite(sc_img,sc_file_path);

if nargin > 5
    sc_file_path = fullfile(results_path,[img_name '_masked_cs.jpg']);
    imwrite(masked_sc_img,sc_file_path);    
end