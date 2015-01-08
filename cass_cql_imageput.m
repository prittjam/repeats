function cass_cql_imageput(cid, data, attribute, opt)
if ~exist('opt','var'), opt = struct(); end;

if iscell(cid), cid = cid{1}; end

runHooks = true;

rawKey = ':raw';
rawPos = strfind(attribute,rawKey);
if length(attribute) - rawPos + 1 == length(rawKey) % must be a suffix
  runHooks = false;
  attribute = attribute(1:(rawPos-1));
  if ~isa(data,'uint8')
    error('Raw data must be of type "uint8".');
  end
  if size(data,2) ~= 1
    error('Raw data must be a column vector.');
  end
  data = typecast(data,'int8');
end

tablename = cass_cql_gettablename(attribute,opt);
storage = cass_cql_handle(struct('table',tablename));

keys = storage.buildKeys(cid, attribute);
values = storage.buildValues(data);

storage.store(keys, values, runHooks);
end