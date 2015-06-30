classdef dr < matlab.mixin.Copyable
    properties(Access=public)
        read_cache
        write_cache
    end

    methods
        function this = dr(prev,varargin)
            this.read_cache = 'On';
            this.write_cache = 'On';
        end

        function [] = set_read_cache(x)
            this.read_cache = x;
        end

        function x = get_read_cache()
            x = this.read_cache;
        end

        function [] = set_write_cache(x)
            this.write_cache = x;
        end

        function x = get_write_cache()
            x = this.write_cache;
        end

    end
end