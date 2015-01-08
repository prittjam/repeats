function result = cass_cql_imagecheck(cid, attribute, opt)
if ~exist('opt','var'), opt = struct(); end;
if iscell(cid), cid = cid{1}; end

% Remove :raw from the attribute
rawPos = strfind(attribute,':raw');
if rawPos
  attribute = attribute(1:(rawPos-1));
end

tablename = cass_cql_gettablename(attribute,opt);
storage = cass_cql_handle(struct('table',tablename));

keys = storage.buildKeys(cid, attribute);

result = storage.exist(keys);
end