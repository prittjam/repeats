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

        function [mle_model,mle_res,mle_stats] = fit(this,x,M00,res,varargin)
            N = size(x,2);
            Gapp = varargin{2};
            G = findgroups(Gapp);
            [loss0,E,pattern_printer] = this.eval.calc_loss(x,M00,varargin{:});
            if ~isempty(pattern_printer)
                [mle_model,mle_stats] = ...
                    pattern_printer.fit('MaxIterations', ...
                                        this.max_iter);               
                inl = ~isnan(mle_model.Gs);
                err = this.eval.reprojT*ones(1,N);
                err(~isnan(mle_model.Gs)) = mle_stats.sqerr;
                cs = this.eval.calc_cs(err);
                loss = sum(err);
                assert(loss <= loss0, 'likelihood decreased!');
                mle_res = struct('loss', loss, ...
                                 'err', err, ...
                                 'cs', cs);
            end
        end
    end
end