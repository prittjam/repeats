function [dr,affpt] = flatten(desc)
dr = struct('u',[], ...
            'desc',[], ...
            'drid',[]);
maxid = 0;
tmp = ceil(log2(numel(desc)-1))+1;
ind = find(cellfun(@(x) ~isempty(x),desc));

for k = ind
    for k2 = 1:numel(desc{k}.affpt)
        desc{k}.affpt(k2).class = ...
            bitor(uint32(bitshift(desc{k}.affpt(k2).class,tmp)),uint32(k-1));
    end
    dr.u = cat(2,dr.u,LAF.from_affpt(desc{k}.affpt));
    dr.drid = cat(2,dr.drid,[desc{k}.affpt(:).class]);
    dr.desc = cat(2,dr.desc, ...
                  reshape([desc{k}.affpt(:).desc],128,[]));
end
dr.num_dr = size(dr.desc,2);