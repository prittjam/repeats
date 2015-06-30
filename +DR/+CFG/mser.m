classdef mser < DR.CFG.dr 
    properties(Access = public)
        verbose = 1;
        relative = 0;
        preprocess = 1;
        export_image = 1;
        min_size = 30;
        min_margin = 10;
        max_area = 0.01;
        use_hyst_thresh = 0;
        low_factor = 0.9;
        precise_border = 0;
        subsample_to_minsize = 0;
        chroma_thresh = 0.09;
        min_areadiff = 0.1;
        nms_method = 0;
    end

    methods
        function this = mser(varargin)
            this = this@DR.CFG.dr(varargin{:});
            if ~isempty(varargin)
                this = helpers.vl_argparse(this,varargin{:});
            end
        end
    end
end 