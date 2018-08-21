function Gr = group_reflections(dr)
tmp = squeeze(struct2cell(dr)); 
names = tmp(4,:);
Gnames = categorical(names);
Gunames = findgroups(Gnames);

is_reflected = cellfun(@(u) numel(strfind(u,'ReflectImg:')),names);
keyboard;

Gr = reshape(is_reflected(findgroups([dr.uname])),1,[]);

