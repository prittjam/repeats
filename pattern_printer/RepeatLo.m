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
        motion_model = 'Rt';
    end

    methods
        function this = RepeatLo(eval,varargin)
            [this,~] = cmp_argparse(this,varargin{:});
            this.eval = eval;
        end

        function [mle_model,mle_res,mle_stats] = fit(this,x,M0,res,varargin)
            N = size(x,2);
            
            good_cspond = res.info.cspond(:,res.cs);
            Gm = res.info.Gm(res.cs);
            
            Rtij = res.info.Rtij;

            pattern_printer = PatternPrinter2(x,M0.cc,Gm,M0.q, ...
                                              M0.A,M0.l,Rtij,good_cspond, ...
                                              'motion_model', this.motion_model);
            [mle_model,mle_stats] = pattern_printer.fit('MaxIterations',this.max_iter); 

            xp = PT.renormI(blkdiag(mle_model.H,mle_model.H,mle_model.H)*PT.ru_div(x,mle_model.cc,mle_model.q));
            [loss,E,cs0] = calc_loss(x,xp,res.info.cspond,res.cs, ...
                                 res.info.Gm,mle_model.q, mle_model.cc,mle_model.H, ...
                                 mle_model.Rtij,this.eval.reprojT);

            xu = PT.ru_div(x,mle_model.cc,mle_model.q);

            Einl = find(cs0);           
            side_inl = unique(find(label_best_orientation(xu,res.info.cspond(:,Einl),mle_model.l)));
            inl = Einl(side_inl);
            cs = false(1,size(res.info.cspond,2));
            cs(inl) = true;

            loss_info = struct('cspond', res.info.cspond, ...
                               'Gm', res.info.Gm, ...
                               'Rtij', mle_model.Rtij);
            mle_res = struct('loss', loss, ...
                             'err', E, ...
                             'info',loss_info, ...
                             'cs', cs);            

            are_same = PT.are_same_orientation(xu(:,unique(res.info.cspond(:,mle_res.cs))),mle_model.l);
            assert(loss <= res.loss,'Likelihood Decreased!');           
            assert(are_same, ...
                   ['There are measurements on both sides of the vanishing line!']);
        end
    end
end
