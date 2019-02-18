%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
classdef RepeatEval < handle
    properties    
        max_iter = 10;
        vqT = 10;
        reprojT = 10;
    end
    
    methods (Static)
        function [loss,E,pattern_printer] = ...
                calc_loss_impl(x,G,M00,vqT,reprojT)         
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
            
            [good_cspond,Rtij00,d200] = resection(x,M0,G,'Rt',vqT); 
            
            E = reprojT*ones(1,N);
            loss = sum(E);
            pattern_printer = [];

            if ~isempty(good_cspond)
                [rtree,X,Rtij0,Tlist,d20] = ...
                    make_scene_graph(x,good_cspond,M0,Rtij00,vqT);
                [Rtij,Gm,needs_inverted] = ...
                    segment_motions(x,M0,rtree.Edges.EndNodes',Rtij0,vqT);
                
                Gs = nan(1,N);
                inl = unique(rtree.Edges.EndNodes);
                Gs(inl) = findgroups(G(inl));

                pattern_printer = ...
                    PatternPrinter(M00.cc,x,rtree,Gs,Tlist, ...
                                   Gm,needs_inverted,q,A,M00.l,X,Rtij, ...
                                   'motion_model', 'Rt');
                
                E0 = pattern_printer.calc_err();
                E = ones(1,N)*reprojT;
                E(~isnan(Gs)) = sum(reshape(E0,6,[]).^2);
                loss = sum(E);
            end
        end
    end 
    
    methods
        function this = RepeatEval(varargin)
            [this,~] = cmp_argparse(this,varargin{:});
        end        
       
        function [loss,E,pattern_printer] = calc_loss(this,x,M00,varargin)         
            Gapp = varargin{2};
            G = findgroups(Gapp);
            [loss,E,pattern_printer] = ...
                RepeatEval.calc_loss_impl(x,G,M00,this.vqT,this.reprojT);
        end

        function cs = calc_cs(this,E)
            cs = E < this.reprojT;
        end                        
    end
end
