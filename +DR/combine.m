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
    m = LAF.from_affpt(desc{k}.affpt);
    t = [desc{k}.affpt(:).desc]';
    dr = cat(2, dr, struct('u', mat2cell(m,9,ones(size(m,2),1)), ...
                    'desc', mat2cell(t, 128*ones(1,numel(t)/128),1)', ...
                    'drid', {desc{k}.affpt(:).class}));
end

% dr.num_dr = size(dr.desc,2);