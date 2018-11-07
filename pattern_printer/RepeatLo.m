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
        end

        function [mle_model,mle_res,mle_stats] = fit(this,x,M00,res,varargin)
            N = size(x,2);
            Gapp = varargin{2};
            G = findgroups(Gapp);
            [loss0,E,pattern_printer] = eval.calc_loss(x,G,M00);         
            if ~isempty(pattern_printer)
                [mle_model,mle_stats] = ...
                    pattern_printer.fit('MaxIterations',this.max_iter);
                err = this.reprojT*ones(1,N);
                err(~isnan(mle_model.Gs)) = mle_stats.sqerr;
                err(err > this.reprojT) = this.reprojT;
                loss = sum(err);
                assert(loss <= loss0, ...
                       'likelihood decreased!');
                mle_res = struct('loss', loss, ...
                                 'err', err, ...
                                 'cs', eval.calc_cs(err));
            end
        end
    end
end
