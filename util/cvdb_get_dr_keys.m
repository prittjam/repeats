function varargout = cvdb_get_dr_keys(cfg)
keys = {};
[subtypes,ids,subgenids] = cvdb_get_dr_subtypes(cfg);
if isempty(subtypes)
    keys{1} = [cfg.detector.name ':' cfg.dhash];
else
    for t2 = 1:numel(subtypes)
        keys{t2} = [cfg.detector.name ':' subtypes{t2} ':' cfg.dhash];
    end
end

varargout{1} = keys;

if nargout > 1
    varargout{2} = subtypes;
    varargout{3} = ids;
    varargout{4} = subgenids;
end