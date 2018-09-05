function [] = cvpr18_demo(img_path)
repeats_init();
cache_params = { 'read_cache', true, ...
                 'write_cache', true };

%file_pattern_list{1} = fullfile(img_path, 'building_us.jpg');
%file_pattern_list{1} = fullfile(img_path,'tran_1_046.jpg');
%
file_pattern_list{1} = fullfile(img_path,'*.jpg');
file_pattern_list{2} = fullfile(img_path,'*.png');
file_pattern_list{3} = fullfile(img_path,'*.JPG');

img_files = [];
for k = 1:numel(file_pattern_list)
    img_files = cat(1,img_files,dir(file_pattern_list{k}));    
end

name_list = { 'H2.5qlu', 'H3qlsu', 'H3.5qluv', 'H4qlusv' };
solver_list = {@WRAP.laf2_to_qlu, ...
               @WRAP.laf2_to_qlsu, ...
               @WRAP.laf22_to_qluv, ...
               @WRAP.laf22_to_qlusv};

[cur_path, name, ext] = fileparts(mfilename('fullpath'));


demo();