function A = normalize(arcs, A)
    arcs = cellfun(@(x) A * x, arcs, 'UniformOutput', false);
end
