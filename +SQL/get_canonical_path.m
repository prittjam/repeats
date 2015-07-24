function ourl = get_canonical_path(iurl)
[ipath,name,ext] = fileparts(iurl);
if isempty(ipath)
    ipath = pwd;
end
opath = cd(cd(ipath));
ourl = [opath '/' name ext];
