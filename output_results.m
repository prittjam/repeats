function [] = output_results(img,rimg,ud_img)
[~,file_name,file_ext] = fileparts(img.url);
imwrite(rimg,['rect_' file_name file_ext]); 
if nargin == 3
    imwrite(ud_img,['ud_' file_name file_ext]);    
end
