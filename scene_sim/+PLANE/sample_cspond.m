%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,idx,G] = sample_cspond(sample_type,varargin)
    cfg = struct('rigidxform', 'Rt');
    cfg = cmp_argparse(cfg,varargin{:});
    
    switch cfg.rigidxform
      case 't'
        make_cspond_same = str2func('PLANE.make_same_t_group');
        make_group = str2func('PLANE.make_t_group');
      case 'Rt'
        make_cspond_same = str2func('PLANE.make_same_Rt_group');
        make_group = str2func('PLANE.make_Rt_group');
    end

    switch sample_type
      case '2'
        [X,cspond,G] = make_group(2)        
        
      case '22s'
        [X,cspond,G] = make_cspond_same(2);
        
      case '22'
        [X,cspond,G] = make_group([2 2]);

      case '222'
        [X,cspond,G] = make_group([2 2 2]);
       
      case '32'
        [X,cspond,G] = make_group([3 2]);
        
      case '4'
        [X,cspond,G] = make_group(4);
    end

    uG = unique(G);

    for k = 1:numel(uG)
        idx{k} = find(G == uG(k));
    end