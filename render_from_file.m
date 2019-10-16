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
load('/home/jbpritts/Desktop/paper/20191014_214727/insidemilan.mat');
model = model_list(end);

render_settings =  ...
    { 'min_scale', 1e-5, ...
      'max_scale', 300, ...
      'scale_output', 6 };

[uimg,rimg,rd_div_line_img] = ...
    render_imgs(img.data,meas,model_list(1),res_list(1),...
                render_settings{:});

rd_div_line_img = ...
    LINE.render_rd_div(img.data,model.q,model.cc,model.l);

save_imgs('~/src/repeats/tmp',img_path, ...
          uimg,rimg, ...
          [],rd_div_line_img)