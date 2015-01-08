function [result, errmessage] = cass_cql_imageget(cid, attribute, opt)
	errmessage = [];
	if ~exist('opt','var'), opt = struct(); end;		

	if iscell(cid), cid = cid{1}; end

	runHooks = true;

	rawPos = strfind(attribute,':raw');
	if rawPos
		runHooks = false;
		attribute = attribute(1:(rawPos-1));
	end

	tablename = cass_cql_gettablename(attribute,opt);
	storage = cass_cql_handle(struct('table',tablename));

	keys = storage.buildKeys(cid, attribute);
	cass_res = storage.load(keys, runHooks);

	% In case the row does not exist, return empty array
	if isempty(cass_res)
		result = [];
		errmessage = 'missing';
		return;
	end

	result = cass_res.data;

	if rawPos
		arr = typecast(result.array, 'uint8');
		% Take only the data without the cassandra header
		result = arr((result.position+1):end);
	end

end