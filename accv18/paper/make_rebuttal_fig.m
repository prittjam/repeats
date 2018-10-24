function [] = make_rebuttal_fig
close all;
bright = 1.7;
img_name = 'cropped_dartboard';
img = Img('url',['data/' img_name '.jpg']);  
[ny,nx,~] = size(img.data);
dims = [ny nx];
dbfile = [ fileparts(which('repeats_init.m')) '/features.db'];
kvdb = KeyValDb.getObj('dbfile', dbfile);
cid_cache = CidCache(img.cid, ...
                     { 'read_cache', true, ...
                    'write_cache', true });
dr = DR.get(img,cid_cache, ...
                {'type','all', ...
                 'reflection', false });
x = [dr(:).u];

load('output/cropped_dartboard_H4ql.mat');
output_image(x,img,model_list,stats_list);

load('output/cropped_dartboard_H222ql.mat');
output_image(x,img,model_list,stats_list);

load('output/cropped_dartboard_H32ql.mat');
output_image(x,img,model_list,stats_list);


function [] = output_image(x,img,model_list,stats_list)
cropped = img.data(200:875,1:555,:);
rect = [1 200 555 875]-0.5;
colors = {'g','r','c'};


figure;
image([rect(1) rect(2)], [rect(3) rect(4)], cropped);
axis equal;
axis tight;
axis off;
hold on;
LAF.draw(gca, x(:,stats_list.ransac(end).res.mss{1}), ...
         'Color','w', 'LineWidth',5);
LAF.draw(gca, x(:,stats_list.ransac(end).res.mss{1}), ...
         'Color','g','LineWidth',3);
hold off;
export_fig('/home/jbpritts/Documents/accv18/fig/H4ql.png');


[ny,nx,~] = size(img.data);
dims = [ny nx];

ind = find(~isnan(model_list(1).Gs));
v = reshape(x(:,ind),3,[]);
H = model_list(1).A;
H(3,:) = transpose(model_list(1).l);
cc = model_list(1).cc;
q = model_list(1).q;

boundary = IMG.rect_to_boundary(rect);
[rimg,trect,tform] = IMG.ru_div_rectify(img.data,H,cc,q, ...
                                        'cspond', v, ...
                                        'boundary',boundary, ...
                                        'Registration','Similarity', ...
                                        'Dims',dims);

figure;
image([trect(1) trect(2)],[trect(3) trect(4)],rimg);
axis off;
axis equal;
axis ij;

hold on;
for k = 1:numel(stats_list.ransac(end).res.mss)
    y = LAF.warp_fwd(x(:,stats_list.ransac(end).res.mss{k}), tform);
    LAF.draw(gca,y,'Color','w', 'LineWidth',5);
    LAF.draw(gca, y, 'Color',colors{k},'LineWidth',3);
end
hold off;

figure;
[uimg,trect,tform] = IMG.ru_div(img.data,cc,q);
image([trect(1) trect(2)],[trect(3) trect(4)],uimg);
axis equal;
axis ij;
axis off;
y = LAF.warp_fwd(x(:,stats_list.ransac(end).res.mss{1}), ...
                 tform);
hold on;
for k = 1:numel(stats_list.ransac(end).res.mss)
    y = LAF.warp_fwd(x(:,stats_list.ransac(end).res.mss{k}), tform);
    LAF.draw(gca, y, 'Color','w', 'LineWidth',5);
    LAF.draw(gca, y, 'Color',colors{k},'LineWidth',3);
end

hold off;