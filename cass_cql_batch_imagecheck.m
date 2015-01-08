function result = cass_cql_batch_imagecheck(cids, attribute, opt)
if ~exist('opt','var'), opt = struct(); end;
if ~iscell(cids), cids = {cids}; end
if iscell(attribute), error('batch_imagecheck supports only a single attribute'); end;
if size(cids,1) > size(cids,2), cids = cids'; end

% Remove :raw from the attribute
rawPos = strfind(attribute,':raw');
if rawPos
  attribute = attribute(1:(rawPos-1));
end

tablename = cass_cql_gettablename(attribute,opt);
storage = cass_cql_handle(struct('table',tablename));
keyspace = storage.Keyspace;

seps = cell(1,numel(cids));
seps(:) = {''', '''}; seps{end} = '';
cidStrs = [cids;seps];

query = ['SELECT COUNT(1) FROM ' keyspace '.' tablename ' WHERE cid IN ( ''' cidStrs{:} ''') AND key = ''' attribute ''';' ];

results = storage.execute(query);

row = results.one();
numFound = row.getLong(0);

result = (numFound == numel(cids));

end