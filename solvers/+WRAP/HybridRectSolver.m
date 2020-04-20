classdef HybridRectSolver < handle & matlab.mixin.Heterogeneous
    properties
        mss = [];
        sample_type = [];
    end

    methods
        function this = HybridRectSolver(sample_type)
            if nargin > 0
                this.set_sample_type(sample_type);
            end
        end
        
        function [] = set_sample_type(this,sample_type)
            switch sample_type
                case 'r2'
                    this.mss = { [2], [] };;

                case 'r22'
                    this.mss = { [2 2], [] };

                case 'r22s'
                    this.mss = { [2 2], [] };

                case 'r222'
                    this.mss = { [2 2 2], [] };

                case 'r32'
                    this.mss = { [3 2], [] };

                case 'r4'
                    this.mss = { [4], [] };

                case 'r2c2'
                    this.mss = { [2], [2] };

                case 'c222'
                    this.mss = { [], [2 2 2] };

                case 'c222s'
                    this.mss = { [], [2 2 2] };

                case 'c32'
                    this.mss = { [], [3 2] };

                case 'p2x3'
                    this.mss = { [3], []};
              otherwise
                throw('Incorrect sample type for rectifying solvers');
            end

            this.sample_type = sample_type;
        end
            
        function flag = is_sample_good(this,meas,idx)
            x = meas{1};
            arcs = meas{2};

            rgn_idx = idx{1};
            rgn_mss = this.mss{1};
            arc_idx = idx{2};
            arc_mss = this.mss{2};

            x3 = reshape(x(:,[rgn_idx{:}]),3,[]);
            [c,ia,ib] = uniquetol(x3',1e-3,'ByRows',true);
            flag1 = numel(ia) == size(x3,2);
            flag2 = numel(unique([rgn_idx{:}])) == sum(rgn_mss);
            flag = flag1 & flag2;
        end

        function flag = is_valid_real(this,M,cc,varargin)
            flag = false(1,numel(M));
            qflag = true(1,numel(M));
            for k = 1:numel(M)
                if isfield(M,'q')
                    qflag(k) = isreal(M(k).q) & all(~isnan(M(k).q));
                end
                flag(k) = isreal(M(k).l) & all(~isnan(M(k).l));
            end
            flag = flag & qflag;
        end

        function [flag,rflag] = is_model_good(this,meas,idx,M,cc,varargin)
            if ~isfield(M,'q')
                q = zeros(1,numel(M));
            else
                q = [M(:).q];
            end

            rflag = this.is_valid_real(M,cc);
            nq = q*sum(2*cc)^2;
            qflag = (nq <= 0) & (nq > -8);
            flag = qflag & rflag;

            if ~isempty(this.mss{1})
                x = meas{1};
                rgn_idx = idx{1};
                m = [rgn_idx{:}];
                x = x(:,m(:));
                oflag = false(size(qflag));
                if any(flag)
                    ind = find(flag);
                    for k = 1:numel(ind)
                        xp = RP2.ru_div(x,cc,q(ind(k)));
                        oflag(ind(k)) = ...
                            PT.are_same_orientation(xp,M(ind(k)).l);
                    end
                end
                flag = flag & oflag;
            end
        end

        function M = fix(this,meas,idx,M,varargin)
            M = [];
        end
    end
end


% classdef RectSolver < handle & matlab.mixin.Heterogeneous
%     properties
%         mss = [];
%         sample_type = [];
%     end
    
%     methods
%         function this = RectSolver(sample_type)
%             switch sample_type
%               case '2'
%                 this.mss = 2;
                
%               case '22'
%                 this.mss = [2 2];
                
%               case '22s'
%                 this.mss = [2 2];

%               case '222'
%                 this.mss = [2 2 2];
                                
%               case '32'
%                 this.mss = [3 2];
                
%               case '4'
%                 this.mss = 4;
                
%               otherwise
%                 throw('Incorrect sample type for rectifying solvers');
%             end
            
%             this.sample_type = sample_type;
%         end
       
%         function flag = is_sample_good(this,x,idx)
%             x3 = reshape(x(:,[idx{:}]),3,[]);
%             [c,ia,ib] = uniquetol(x3',1e-3,'ByRows',true);
%             flag1 = numel(ia) == size(x3,2);
%             flag2 = numel(unique([idx{:}])) == sum(this.mss);
%             flag = flag1 & flag2;
%         end    
        
%         function flag = is_valid_real(this,M,cc,varargin)
%             flag = false(1,numel(M));
%             qflag = true(1,numel(M));
%             for k = 1:numel(M)
%                 if isfield(M,'q')
%                     qflag(k) = isreal(M(k).q) & all(~isnan(M(k).q));
%                 end 
%                 flag(k) = isreal(M(k).l) & all(~isnan(M(k).l));
%             end    
%             flag = flag & qflag;
%         end

%         function [flag,rflag] = is_model_good(this,x,idx,M,cc,varargin)
%             m = [idx{:}];
%             x = x(:,m(:));

%             if ~isfield(M,'q')
%                 q = zeros(1,numel(M));
%             else
%                 q = [M(:).q];
%             end
                
%             rflag = this.is_valid_real(M,cc);
%             nq = q*sum(2*cc)^2;
%             qflag = (nq <= 0) & (nq > -8);
%             oflag = false(size(qflag));
%             flag = qflag & rflag;

%             if any(flag)
%                 ind = find(flag);
%                 for k = 1:numel(ind)
%                     xp = PT.ru_div(x,cc,q(ind(k)));
%                     oflag(ind(k)) = ...
%                         PT.are_same_orientation(xp,M(ind(k)).l); 
%                 end
%             end         
%             flag = flag & oflag;
%         end        

%         function M = fix(this,x,idx,M,varargin)
%             M = [];
%         end
%     end
% end