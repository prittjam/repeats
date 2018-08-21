function [Gapp,Gr] = group_desc(dr,varargin)
[cfg,leftover] = cmp_argparse(cfg,varargin{:});
G = DR.group_desc_app(dr);
Gr = DR.group_reflections(dr);

%if cfg.rm_duplicates
%    Gapp = findgroups(msplitapply(@(dr,G) rm_duplicates([dr(:).u],G),dr,Gapp,Gapp));
%end

keyboard;
if ~cfg.group_reflections
    Gr_tmp = Gr;
    Gr_tmp(find(Gr_tmp == 0)) = -1;
    Gapp = findgroups(Gapp.*Gr_tmp);
    freq = hist(Gapp,1:max(Gapp));
    bad_labels = find(freq < 2);
    [~,ind] = ismember(bad_labels,Gapp);
    Gapp(ind) = nan;
    Gapp = findgroups(Gapp);
end