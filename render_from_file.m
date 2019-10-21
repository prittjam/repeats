%load('keep/20191007_203728/45.mat');
%load('keep/20191007_234536/prague.mat')
%load('results/WRAP.laf2_to_ql/20191012_213338/milaninside.mat');
%load('results/WRAP.laf2_to_ql/20191012_225234/china.mat');
%load('results/WRAP.laf2_to_ql/20191012_213338/milaninside.mat');
%load('results/WRAP.laf2_to_ql/20191012_213338/milaninside.mat');
%load('/home/jbpritts/Desktop/paper/20191012_225234/china.mat');
%load('/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/20191012_233925/45.mat')
%load('/home/jbpritts/Desktop/paper/20191012_222914/smmilan6.mat');
%img = imread('/home/jbpritts/Desktop/paper/20191012_222914/smmilan6.jpg');
%load('/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/20191014_203351/tower.mat')
%load(['/home/jbpritts/Desktop/paper/20191014_214727/' ...
%      'insidemilan.mat']);
%load('/home/jbpritts/Desktop/paper/20191014_225210/4.mat');
%load('/home/jbpritts/Desktop/paper/20191014_200242/china.mat');
%load('/home/jbpritts/Desktop/keep/20191006_235729/new_medium_63_o.mat');
%load(['/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/20191018_200225/new_medium_63_o.mat']);
%load('/home/jbpritts/Desktop/paper/20191014_210613/green_portal.mat');
%load(['/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/' ...
%      '20191019_233254/china.mat']);
%
%load('/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/20191020_112921/green_portal.mat')
%load('/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/20191018_182306/42.mat');
%load('/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/20191019_233254/china.mat');
repeats_init
load('/home/jbpritts/src/repeats/results/WRAP.laf2_to_ql/20191020_212348/barrels.mat');
model = model_list(end);
render_settings =  ...
    { 'min_scale', 1e-5, ...
      'max_scale', 155, ...
      'scale_output', 3, ...
    'Registration', 'Affinity'};
[uimg,rimg,rd_div_line_img] = ...
    render_imgs(img.data,meas,model_list(1),res_list(1),...
                render_settings{:});
rd_div_line_img = ...
    LINE.render_rd_div(img.data,model.q,model.cc,model.l);
save_imgs('~/src/repeats/tmp',img_path, ...
          uimg,rimg, ...
          [],rd_div_line_img)