function Gr = group_reflections(dr)
unames = categories([dr(:).uname]);
is_reflected = cellfun(@(u) numel(strfind(u,'ReflectImg:')),unames);
Gr = reshape(is_reflected(findgroups([dr.uname])),1,[]);
