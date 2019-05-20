%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [res,gt,cam] = make_samples(varargin)
    repeats_init;
    cfg = struct('nx', 1000, ...
                 'ny', 1000, ...
                 'cc', [], ...
                 'rigidxform', 'Rt', ...
                 'numscenes', 1000, ...
                 'ccdsigmalist', [0], ...
                 'normqlist',-4);

    cfg = cmp_argparse(cfg,varargin{:});

    wplane = 10;
    hplane = 10;

    sample_type_strings = ...
        {'laf2','laf22','laf22s','laf222','laf32','laf4'};

    sample_type_list = categorical(1:numel(sample_type_strings),...
                                   1:numel(sample_type_strings), ...
                                   sample_type_strings, ...
                                   'Ordinal',true);
    ex_num = 1;

    xx{1} = zeros(9,6,cfg.numscenes); 
    xx{2} = zeros(9,5,cfg.numscenes);
    xx{3} = zeros(9,4,cfg.numscenes);
    
    for scene_num = 1:cfg.numscenes
        f = 5*rand(1)+3;
        cam = CAM.make_ccd(f,4.8,cfg.nx,cfg.ny);
        P = PLANE.make_viewpoint(cam);
        cspond_dict = containers.Map;
        usample_type = {'222','32','4'};
        for k = 1:numel(usample_type)
            Xlist = {};
            cspond = {};
            [X,cspond,idx] = ...
                PLANE.sample_cspond(usample_type{k},10,10, ...
                                    'RigidXform','Rt');
            keyboard;
            X4 = reshape(X,4,[]);
            x = PT.renormI(P*X4);
            q_gt = -4/sum(2*cam.cc)^2;
            keyboard;
            xx{k}(:,:,scene_num) = reshape(CAM.rd_div(reshape(x,3, ...
                                                              []),cam.cc,q_gt),9,[]);
        end
    end

keyboard;

save('viktor.mat','xx');