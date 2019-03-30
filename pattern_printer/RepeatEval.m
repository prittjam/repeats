%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef RepeatEval < handle
    properties    
        max_iter = 10;
        reprojT = 10;
    end
    
    methods
        function this = RepeatEval(varargin)
            [this,~] = cmp_argparse(this,varargin{:});
        end        
        
        function [cs,d2] = label_inliers(this,x,xu,xp,M0,cspond,Rtij)
            cost = calc_cost(x,xp,cspond,1:size(cspond,2),M0.q,M0.cc,M0.H,Rtij);            
            [~,side] = PT.are_same_orientation(xu,M0.l);
            d2 = sum(cost.^2);
            d2inl = find(d2 < this.reprojT);
            sides = side(cspond(:,d2inl));
            [~,best_side] = max(hist(sides(:),[1,2]));
            side_inl =  find(all(sides == best_side));
            inl = d2inl(side_inl);
            cs = false(size(inl));
            cs(inl) = true;
            inlx = unique(cspond(:,inl));
            
            if numel(inlx) > 0
                [are_same,side] = ...
                    PT.are_same_orientation(xu(:,inlx),M0.l);
                assert(are_same, ...
                       ['There are measurements on both sides of the ' ...
                        'vanishing line!']);            
            end
        end
            
        function [loss,E,loss_info] = calc_loss(this,x,M0,varargin)         
            G = findgroups(varargin{2});
            loss_info = struct;
            
            xu = PT.ru_div(x,M0.cc,M0.q);
            xp = PT.renormI(blkdiag(M0.H,M0.H,M0.H)*xu);
            
            [cspond,Rtij0] = resection(xp,G,'Rt');             
            [cs,E] = this.label_inliers(x,xu,xp,M0,cspond,Rtij0);
            E(E > this.reprojT) = this.reprojT;
            loss = sum(E);
            Gm = nan(1,size(cspond,2));
            
            if any(cs)
                inl = find(cs);
                [Rtij,Gm(inl),needs_inverted] = ...
                    segment_motions(x,M0,cspond(:,inl),Rtij0(:,:, ...
                                                             inl),this.reprojT);
                [cspond(1,inl(needs_inverted)), ...
                 cspond(2,inl(needs_inverted))] = ...
                    deal(cspond(2,inl(needs_inverted)), ...
                         cspond(1,inl(needs_inverted)));

                [loss,E] = calc_loss(x,xp,cspond,cs,Gm,M0.q,M0.cc,M0.H,Rtij,this.reprojT);

                assert(all(~isnan(Gm(this.calc_cs(E)))), ...
                       'You have issues');
                
                loss_info = struct('cspond', cspond, ...
                                   'Gm', Gm, ...
                                   'Rtij', Rtij);
            end
        end

        function cs = calc_cs(this,E)
            cs = E < this.reprojT;
        end                        
    end
end
