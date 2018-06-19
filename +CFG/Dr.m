classdef Dr 
    properties(Access = public)
        dr_type = 'all';
        reflection = 1;
    end
    
    methods
        function this = Dr(varargin)
            leftover = [];
            if ~isempty(varargin)
                if numel(varargin) > 1
                    [this,leftover] = ...
                        cmp_argparse(this,varargin{:});
                elseif isa(varargin{1},'CFG.Dr')
                    this = copy(varargin{1});
                end
            end
        end
    end
end