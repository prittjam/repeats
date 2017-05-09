% Copyright (c) 2017 James Pritts
% 
classdef laf1x2_to_lvks
    properties
        mss = 1;
        A = [];
        invA = [];
    end
    
    methods
        function this = laf1x2_to_lvks(cc)
            this.A = CAM.make_fitz_normalization(cc);
            this.invA = inv(this.A);
        end

        function M = fit(this,dr,corresp,idx)
            m  = corresp(:,idx);
            un = blkdiag(this.A,this.A,this.A)*[dr(m(:)).u];
            ung = reshape(un,18,[]);
            M = HG.laf1x2_to_lvks(ung);
            for i = 1:numel(M)
                M{i}.Hv = eye(3)+M{i}.s*M{i}.v*M{i}.l';
                M{i}.Hv = this.invA*M{i}.Hv*this.A;
                M{i}.l = this.A'*M{i}.l;
                M{i}.v = this.invA*M{i}.v;
            end
        end
        
        function flag = is_sample_good(this,dr,corresp,idx)
            flag = true;
        end    

        function flag = is_model_degen(this,dr,corresp,M) 
            flag = false(1,numel(M));
            ind = reshape(unique(corresp),1,[]);
            keyboard;
            u = [dr(ind).u];
            for k = 1:numel(M)
                H = M{k};
                l = H(3,:)';
                flag = PT.are_same_orientation(u,l); 
            end
        end        
    end
end
