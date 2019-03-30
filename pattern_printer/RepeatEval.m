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
        
        function [loss,E,cs,loss_info] = calc_loss(this,x,M0,varargin)         
            G = findgroups(varargin{2});
            loss_info = struct;
            
            xu = PT.ru_div(x,M0.cc,M0.q);
            xp = PT.renormI(blkdiag(M0.H,M0.H,M0.H)*xu);
            
            [cspond,Rtij0] = resection(xp,G,'Rt');             
            n = size(cspond,2);
            
            [loss,E,cs0] = calc_loss(x,xp,cspond,1:n,1:n,M0.q,M0.cc,M0.H,Rtij0,this.reprojT);

            Einl = find(cs0);           
            side_inl = unique(find(label_best_orientation(xu,cspond(:,Einl),M0.l)));
            inl = Einl(side_inl);
            cs = false(1,n);
            cs(inl) = true;

            Gm = nan(1,n);

            if any(cs)
                inlx = unique(cspond(:,inl));
                [are_same,side] = ...
                    PT.are_same_orientation(xu(:,inlx),M0.l);
                assert(are_same, ...
                       ['There are measurements on both sides of the ' ...
                        'vanishing line!']);            

                inl = find(cs);
                [Rtij,Gm(inl),needs_inverted] = ...
                    segment_motions(x,M0,cspond(:,inl),Rtij0(:,:,inl),this.reprojT);
                [cspond(1,inl(needs_inverted)), ...
                 cspond(2,inl(needs_inverted))] = ...
                    deal(cspond(2,inl(needs_inverted)), ...
                         cspond(1,inl(needs_inverted)));

                cs(isnan(Gm)) = false;
                [loss,E,cs] = calc_loss(x,xp,cspond,cs,Gm,M0.q,M0.cc,M0.H,Rtij,this.reprojT);

                assert(all(~isnan(Gm(cs))), 'Invalid motions found.');

                loss_info = struct('cspond', cspond, ...
                                   'Gm', Gm, ...
                                   'Rtij', Rtij);
            end
        end
       
    end
end
