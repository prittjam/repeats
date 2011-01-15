function cfghash = cfg2db(conn, table, struct_to_save)
% CFG2DB stores structure into a database table
%    CFG2DB(CONN, TABLE, STRUCT) stores a structure STRUCT into table
%    TABLE, creating new columns for the structure members as required.
%
%    Example:
%       s = struct('test', 3, 'struct', 4, 'to', 'db')
%       conn = dbconn('test', 'evaluator', '');
%       struct2db(conn, 'cfg_test_table', s);
%
   fprintf('Saving configuration to DB...\n'); tic;
   
   % find the hash of structure
   [cfghash json] = cfg2hash(struct_to_save);
   
   cursor = fetch(exec(conn, sprintf('select * from %s where structure_hash = ''%s''', table, cfghash)));
   if (rows(cursor) == 0)
      % flatten structure first
      [values fields] = flatten_nested_struct(struct_to_save);
      struct_to_save = cell2struct(values, fields);
      
      % add some specially handled fields
      struct_to_save.structure_hash = cfghash;
      struct_to_save.structure_json = json;
      
      struct2db(conn, table, struct_to_save);
   else
      fprintf('  Configuration already exists in the database.\n');
   end;

   done;
