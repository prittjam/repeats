classdef Mserm < MSER.CFG.Mser
    methods 
        function this = Mserm(varargin)
            this@MSER.CFG.Mser(varargin{:});
        end

        function uname = get_uname(this)
            uname = 'Mserm';
        end
    end
end