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
            
            cspond = res.info.cspond(:,res.cs);
            Gm = res.info.Gm(res.cs);
            Rtij = res.info.Rtij;

            pattern_printer = PatternPrinter2(x,M0.cc,Gm,M0.q, ...
                                              M0.A,M0.l,Rtij,cspond);
            [mle_model,mle_stats] = pattern_printer.fit('MaxIterations',this.max_iter); 

            E0 = calc_cost(x,cspond,Gm,...
                           mle_model.q,mle_model.cc, ...
                           mle_model.Hr,mle_model.Rtij);
            E = ones(1,size(res.info.cspond,2))*res.info.reprojT;
            E(res.cs) = sum(E0.^2);

            loss = sum(E);           
            cs = this.eval.calc_cs(E);
            mle_res = struct('loss', loss, ...
                             'err', E, ...
                             'cs', cs, ...
                             'info',res.info);
            inlx = unique(res.info.cspond(:,res.cs));
            are_same = PT.are_same_orientation(x(:,inlx),M0.l);

            assert(loss <= res.loss,'Likelihood Decreased!');           
            assert(are_same, ...
                   ['There are measurements on both sides of the vanishing line!']);
        end
    end
end