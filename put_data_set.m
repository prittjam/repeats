function [] = put_data_set(base_path,name)
sql = sqldb;
sql.open();
sql.create();

img_files = get_img_files(base_path);

h = sql.ins_img_set(name,img_files,...
                    'InsertMode','Replace');

function img_files = get_img_files(base_path)
img_files = dir(fullfile(base_path,'*.jpg'));
img_files = cat(1,img_files,dir(fullfile(base_path,'*.JPG')));
img_files = cat(1,img_files,dir(fullfile(base_path,'*.png')));
img_files = cat(1,img_files,dir(fullfile(base_path,'*.PNG')));
img_files = cat(1,img_files,dir(fullfile(base_path,'*.gif')));
img_files = cat(1,img_files,dir(fullfile(base_path,'*.GIF')));

img_files = rmfield(img_files,{'date','bytes','isdir','datenum'});
img_files = struct2cell(img_files);
img_files = cellfun(@(x)[base_path '/' x],img_files,'UniformOutput',false);