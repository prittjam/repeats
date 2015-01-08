function [opt, defopt] = optmerge(varargin)
%
% [opt defopt] = optionmerge(o1,o2,...)
%
%    Merges option sets into one. Each option set is a structure with
%    named fields. The merge is again such a structure. If the same
%    parameter is set multiple times the last occurence counts. Since
%    each function must recognize its own parameters and disregard the
%    others it is a good practice to prepend a function identifier to
%    each parameter separated by an underscore (_).
%
%    defopt is options from the first structure, which have not been rewritten
%
% See also: Options

% (c) Radim Sara (sara@cmp.felk.cvut.cz) FEE CTU Prague, 24 Jan 03

    opt = varargin{1};
    defopt = opt;
    if ~isstruct(opt); error 'Parameter set is not a structure'; end

    for i = 2:length(varargin)
        oi = varargin{i};
        if ~isempty(oi)
            if ~isstruct(oi); error 'Parameter set is not a structure'; end

            for fld = fieldnames(oi)'
                opt = setfield(opt, fld{1}, getfield(oi,fld{1})); %merging to opt

                if isfield(defopt, fld{1})
                    defopt = rmfield(defopt, fld{1}); %removing from defopt (it was rewritten)
                end
            end
        end
    end

end
