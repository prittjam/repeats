classdef CfgBase < matlab.mixin.Copyable
    properties(Access=private)
        read_cache
        write_cache
    end

    methods
        function this = CfgBase(varargin)
            this.read_cache = 'On';
            this.write_cache = 'On';
        end

        function [] = set_read_cache(this,x)
            this.read_cache = x;
        end

        function x = get_read_cache(this)
            x = this.read_cache;
        end

        function [] = set_write_cache(this,x)
            this.write_cache = x;
        end

        function x = get_write_cache(this)
            x = this.write_cache;
        end
    end
end