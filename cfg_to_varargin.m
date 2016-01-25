function out = cfg_to_varargin(cfg)
tmp = KEY.class_to_struct(cfg);
fn = fieldnames(tmp);
va = struct2cell(tmp);
out = cell(1,2*numel(va));
out(1:2:end-1) = fn;
out(2:2:end) = va;