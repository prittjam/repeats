function [] = put_data_set(base_path,name)
sql = SqlDb;
sql.open('cfg_file', ...
         '~/src/cvdb/sqldbcfgs/zornsqldb.cfg');
imagedb = ImageDb('cfg_file', ...
                  '~/src/cvdb/casscfgs/lascarremote.cfg');

img_urls = get_img_urls(base_path);

for k = 1:numel(img_urls)
    cids{k} = imagedb.put_img(img_urls{k});
end

cids = sql.put_img_set(name,img_urls,...
                       'InsertMode','Replace');

function img_urls = get_img_urls(base_path)
img_urls = dir(fullfile(base_path,'*.jpg'));
img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.JPG')));
img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.png')));
img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.PNG')));
img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.gif')));
img_urls = cat(1,img_urls,dir(fullfile(base_path,'*.GIF')));

img_urls = rmfield(img_urls,{'date','bytes','isdir','datenum'});
img_urls = struct2cell(img_urls);
img_urls = cellfun(@(x)[base_path '/' x],img_urls,'UniformOutput',false);