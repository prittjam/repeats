function res = extract(cfg_list,img)
syscfg = DR.Syscfg();
gens = syscfg.go_chain(cfg_list);
names = cellfun(@(x) cellfun(@(y) class(y),x,'UniformOutput',false),gens,'UniformOutput',false);

curi = ones(numel(cfg_list),1);
curgen = cellfun(@(x) x{1}, gens, 'UniformOutput',false);
prevres = cell(1,numel(cfg_list));
sizes = cellfun(@(x) numel(x),cfg_list);

res = cell(1,numel(cfg_list));

while( ~all(cellfun(@(x) isempty(x),curgen)) )
	curname = cellfun(@(x) class(x), curgen, 'UniformOutput',false);
	[uname,ia,ic] = unique(curname,'stable');
	ugens = curgen(ia);
	cfgs = cellfun(@(x,y) x{y},cfg_list,num2cell(curi),'UniformOutput',false);
	notempty = find(~cellfun(@(x) strcmp(x,'double'),curname));
	i = find(notempty(1) == ia);
	same = ic == i;
	prevres(same) = ugens{i}.make(img,cfgs(same),prevres(same));
	fsame = find(same);
	for k = 1:numel(fsame)
		res{fsame(k)}{curi(fsame(k))} = prevres{fsame(k)};
	end
	last = arrayfun(@(x,y) x==y,curi,sizes);
	curi(same & ~last) = curi(same & ~last) + 1;
	curgen = cellfun(@(x,y) x{y}, gens,num2cell(curi'),'UniformOutput',false);
	curgen(last) = {[]};
end
