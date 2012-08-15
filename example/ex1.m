function [] = ex1()
addpath('../');
cvdb_init('../../wbs');

global CVDB_CACHE CASS_CFG conn
global img_idx

CVDB_CACHE.dr = true;
CVDB_CACHE.bb = true;

img_set = scene_get_img_set('eccv12/set3');
img_set = scene_find_img_by_name(img_set,'00.jpg');
scene_load_img_set(img_set);

num_imgs = numel(img_set);

sift_cfg = scene_make_sift_cfg();
detectors{1} = scene_make_mser_cfg([],[]);
detectors{2} = scene_make_haff2_na_cfg([],[]);

dr_set = scene_get_img_set_dr(detectors, ...
                              ~CVDB_CACHE.dr);

for k = 1:numel(img_set)
    img_idx = k;
    [cimg,img_id] = scene_get_cimg(img_idx);
    dr_set{k} = scene_rm_empty_dr(dr_set{k});
    cdr = dr_set{k};

    figure;
    subplot(1,2,1);
    imshow(cimg);rpt_draw2d_mser_plus(gca,cdr);
    subplot(1,2,2);
    imshow(cimg);rpt_draw2d_mser_minus(gca,cdr);
end

function draw2d_lafs(ax1,u,varargin)
x = reshape(u(1:3:end,:),3,[]);
y = reshape(u(2:3:end,:),3,[]);

hold all;
h1 = plot(x,y,'-o', ...
          'LineWidth'       , 2, ...
          'MarkerEdgeColor','k', ...
          'MarkerFaceColor',[.49 1 .63], ...
          'MarkerSize',4, ...
          varargin{:});

plot(x(1:3:end)',y(1:3:end)','o', ...
     'LineWidth'       , 2, ...
     'MarkerEdgeColor','k', ...
     'MarkerFaceColor',[0.43 0.81 0.96], ...
     'MarkerSize',5);
hold off;

function rpt_draw2d_detector_type(ax1,cdr,name,s);
ind = scene_find_detector_type(cdr,name);
u = [cdr(ind).u];
if nargin < 4
    s = [cdr(ind).s];
    s = s(end,:);
end
draw2d_lafs(ax1,u(:,s),'Color',[0 1 0]);

function rpt_draw2d_mser_plus(ax1,cdr)
draw2d_lafs(ax1,cdr(1).u,'Color',[0 1 0]);

function rpt_draw2d_mser_minus(ax1,cdr)
draw2d_lafs(ax1,cdr(2).u,'Color',[0 0 1]);

function rpt_draw2d_haff(ax1,cdr)
draw2d_lafs(ax1,cdr(3).u,'Color',[1 0 0]);
