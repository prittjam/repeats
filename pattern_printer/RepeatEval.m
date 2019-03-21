%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef RepeatEval < handle
    properties    
        max_iter = 10;
        reprojT = 15;
    end
    
    methods
        function this = RepeatEval(varargin)
            [this,~] = cmp_argparse(this,varargin{:});
        end        
       
        function [loss,E,loss_info] = calc_loss(this,x,M00,varargin)         
            Gapp = varargin{2};
            G = findgroups(Gapp);
            N = size(x,2); 
            if ~isfield(M00,'q')
                q = -1e-9;
            else
                q = M00.q;
            end

            A = M00.A;
            H = eye(3);
            H(3,:) = transpose(M00.l);            
            H = A*H;
            M0 = struct('H',H, ...
                        'cc',M00.cc, ...
                        'q', q);
            
            [cspond,Rtij0,inl] = resection(x,M0,G,'Rt',this.reprojT); 
            E = ones(1,size(cspond,2))*this.reprojT;
            loss = sum(E);
            loss_info = struct;
            
            Gm = nan(1,size(cspond,2));
            
            if any(inl)
                [Rtij,Gm(inl),needs_inverted] = ...
                    segment_motions(x,M0,cspond(:,inl),Rtij0(:,:,inl),this.reprojT);
                [cspond(1,inl(needs_inverted)), ...
                 cspond(2,inl(needs_inverted))] = ...
                    deal(cspond(2,inl(needs_inverted)), ...
                         cspond(1,inl(needs_inverted)));

                E0 = calc_cost(x,cspond(:,inl),Gm(inl),q,M0.cc,H,Rtij);
                E(inl) = sum(E0.^2);
                loss = sum(E);
                loss_info = struct('cspond', cspond, ...
                                   'Gm', Gm, ...
                                   'Rtij', Rtij, ...
                                   'reprojT', this.reprojT);
            end
        end

        function cs = calc_cs(this,E)
            cs = E < this.reprojT;
        end                        
    end
end
