classdef Mserp < MSER.CFG.Mser
    methods 
        function this = Mserp(varargin)
            this@MSER.CFG.Mser(varargin{:});
        end

        function uname = get_uname(this)
            uname = 'Mserp';
        end
    end
end