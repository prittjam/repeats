function [dr,affpt] = combine(desc)
dr = [];
maxid = 0;
tmp = ceil(log2(numel(desc)-1))+1;
ind = find(cellfun(@(x) ~isempty(x),desc));

for k = ind
    for k2 = 1:numel(desc{k}.affpt)
        desc{k}.affpt(k2).class = ...
            bitor(uint32(bitshift(desc{k}.affpt(k2).class,tmp)),uint32(k-1));
    end
    dr = cat(2, dr, struct('u', mat2cell(LAF.from_affpt(desc{k}.affpt),9,numel(desc{k})), ...
                    'desc', {desc{k}.affpt(:).desc}, ...
                    'drid', {desc{k}.affpt(:).class}));
end
numel(dr)
dr(1)
dr(2)
% dr.num_dr = size(dr.desc,2);