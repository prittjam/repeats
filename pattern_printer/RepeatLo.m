%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef RepeatLo < handle
    properties
        eval = [];
        max_iter = 10;
    end

    methods
        function this = RepeatLo(motion_model,eval,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            this.eval = eval;
        end

        function [mle_model,mle_res,mle_stats] = fit(this,x,M0,res,varargin)
            N = size(x,2);
            
            good_cspond = res.info.cspond(:,res.cs);
            Gm = res.info.Gm(res.cs);
            
            Rtij = res.info.Rtij;

            pattern_printer = PatternPrinter2(x,M0.cc,Gm,M0.q, ...
                                              M0.A,M0.l,Rtij,good_cspond);
            [mle_model,mle_stats] = pattern_printer.fit('MaxIterations',this.max_iter); 

            xp = PT.renormI(blkdiag(mle_model.H,mle_model.H,mle_model.H)*PT.ru_div(x,mle_model.cc,mle_model.q));
            [loss,E] = calc_loss(x,xp,res.info.cspond,res.cs, ...
                                 res.info.Gm,mle_model.q, mle_model.cc,mle_model.H, ...
                                 mle_model.Rtij,this.eval.reprojT);

            loss_info = struct('cspond', res.info.cspond, ...
                               'Gm', res.info.Gm, ...
                               'Rtij', mle_model.Rtij);
            
            mle_res = struct('loss', loss, ...
                             'err', E, ...
                             'info',loss_info, ...
                             'cs', this.eval.calc_cs(E));
            
            inlx = unique(res.info.cspond(:,res.cs));
            
            xu = PT.ru_div(x,mle_model.cc,mle_model.q);
            are_same = PT.are_same_orientation(xu(:,inlx),M0.l);

            assert(loss <= res.loss,'Likelihood Decreased!');           
            assert(are_same, ...
                   ['There are measurements on both sides of the vanishing line!']);
        end
    end
end