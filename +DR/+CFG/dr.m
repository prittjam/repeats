classdef dr < matlab.mixin.Heterogeneous
    properties(Access=public)
        read_cache
        write_cache
        name
        prev
    end

    methods
        function this = dr(prev,varargin)
            this.read_cache = 'On';
            this.write_cache = 'On';
            this.prev = prev;
            this.name = [];
        end

        function name = set_name(this,current)
            tmp = class(current);
            if isempty(this.prev)
                this.name = tmp(4:end);
            else
                this.name = [this.prev.name ':' tmp(4:end)];
            end
            name = this.name;
        end
    end
end