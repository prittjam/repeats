%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [X,cspond,idx,G] = sample_cspond(sample_type,varargin)
    cfg = struct('rigidxform', 'Rt');
    cfg = cmp_argparse(cfg,varargin{:});
    
    make_cspond_same = str2func(['PLANE.make_cspond_same_' cfg.rigidxform]);
    make_cspond_set = str2func(['PLANE.make_cspond_set_' cfg.rigidxform]);
    
    switch sample_type
      case 'laf2'
        [X,cspond,G] = make_cspond_set(2);        
        
      case 'laf22s'
        [X,cspond,G] = make_cspond_same(2);
        
      case 'laf22'
        [X0,cspond0,G0] = make_cspond_set(2);
        [X1,cspond1,G1] = make_cspond_set(2);
        X = [X0 X1];
        cspond = [cspond0 cspond1+max(cspond0(:))];
        G = [G0 G1+max(G0)];

      case 'laf222'
        [X0,cspond0,G0] = make_cspond_set(2);
        [X1,cspond1,G1] = make_cspond_set(2);
        [X2,cspond2,G2] = make_cspond_set(2);
        X = [X0 X1 X2];
        cspond1 = cspond1+max(cspond0(:));
        cspond2 = cspond2+max(cspond1(:));
        cspond = [cspond0 cspond1 cspond2];
        G1 = G1+max(G0);
        G2 = G2+max(G1);
        G = [G0 G1 G2];
        
      case 'laf32'
        [X0,cspond0,G0] = make_cspond_set(3);
        [X1,cspond1,G1] = make_cspond_set(2);
        X = [X0 X1];
        cspond = [cspond0 cspond1+max(cspond0(:))];
        G = [G0 G1+max(G0)];
        
      case 'laf4'
        [X,cspond,G] = make_cspond_set(4);
    end

    uG = unique(G);
    for k = 1:numel(uG)
        idx{k} = find(G == uG(k));
    end