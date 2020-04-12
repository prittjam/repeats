function A = normalize(arcs, varargin)
    A = CAM.make_norm_xform(varargin{:});
    arcs = cellfun(@(x) A * x, arcs, 'UniformOutput', false);
end
