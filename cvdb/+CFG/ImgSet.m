classdef ImgSet 
    properties(Access = public)
        img_set = 'dggt';
        img_names = [];
        max_num_cores = 1;
        res_path = 'labeling';
    end
    
    methods
        function this = ImgSet(varargin)
            leftover = [];
            if ~isempty(varargin)
                if numel(varargin) > 1
                    [this,leftover] = cmp_argparse(this,varargin{:});
                elseif isa(varargin{1},'CFG.ImgSet')
                    this = copy(varargin{1});
                end
            end
        end
    end
end