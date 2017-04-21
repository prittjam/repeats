function [] = output_results(img,rimg,ud_img)
[~,file_name,file_ext] = fileparts(img.url);
if ~isempty(rimg)
    imwrite(rimg,['/home/prittjam/Desktop/hayko/rect_' file_name file_ext]); 
end
if nargin == 3
    imwrite(ud_img,['/home/prittjam/Desktop/hayko/ud_' file_name file_ext]);    
end
