function struct2db(conn, table, struct_to_save)
% STRUCT2DB stores structure into a database table
%    STRUCT2DB(CONN, TABLE, STRUCT) stores a structure STRUCT into table
%    TABLE, creating new columns for the structure members as required.
%
%    Example:
%       s = struct('test', 3, 'struct', 4, 'to', 'db')
%       conn = dbconn('ir', 'evaluator', 'eval');
%       struct2db(conn, 'test_table', s);
%
   
   %check if we have all the columns
   add_missing_columns(conn, struct_to_save, table);
   
   [fields values] = struct_values_as_str(struct_to_save);
   fastinsert(conn, table, fields, values);
   
   done;
end

function strret = nullize(strval)
   if (strcmpi(strval, 'null'))
      strret = 'NULL';
   else
      strret = sprintf('''%s''', strval);
   end
end

function dbtype = guess_type(value)
   dbtype = 'VARCHAR(255)';
   if (isscalar(value))
      switch class(value)
        case {'double', 'single'}
          dbtype = 'DOUBLE';
        case 'logical'
          dbtype = 'TINYINT';
        case {'int8','uint8','int16','uint16','int32','uint32'}
          dbtype = 'INT';
        case {'int64', 'uint64'}
          dbtype = 'BIGINT';
      end;
   else
      if (numel(value)<5)
         dbtype = 'VARCHAR(255)';
      else
         dbtype = 'TEXT';
      end;
   end
end

function add_missing_columns(conn, tosave, table)
   
   dbcols = columns(dmd(conn), get(conn, 'Catalog'), table, table);
   tosavecols = lower(fieldnames(tosave));
   values = struct2cell(tosave);

   missing = setdiff(lower(tosavecols), lower(dbcols));
   if isempty(missing); return; end
   
   for newcolumn = missing
      fprintf('   Adding new column `%s` into table `%s`.\n', newcolumn{1}, table);
      guess = guess_type(values{find(strcmp(tosavecols,newcolumn))});
      reply = input(sprintf(['   I guess it is a column of %s type but to be sure enter the MySQL data type to use ' ...
                          '{VARCHAR(255), INTEGER, DOUBLE, TINYINT, DATETIME, ...} or press ENTER if you agree with ' ...
                          'my guess: '], guess), 's');
      if isempty(reply) reply = guess; end
      e = exec(conn, sprintf('ALTER TABLE %s ADD COLUMN %s %s NULL DEFAULT NULL FIRST', table, newcolumn{1}, reply));      
   end
end

function [strfields strvalues] = struct_values_as_str(tosave)
   fields = fieldnames(tosave);
   values = struct2cell(tosave);
   strfields = {};
   strvalues = {};
   
   for i = 1:numel(values)
      if (isstruct(values{i})),
         values{i} = struct2str(values{i});
      end
      
      if (numel(values{i}) > 1)
         values{i} = num2str(values{i});
      end
      
      strvalues{end+1} = values{i};
      strfields{end+1} = fields{i};
   end
end

function str = tostr(v)
   if (isempty(v))
      str = 'empty';
   elseif (isnumeric(v) || islogical(v))      
      str = num2str(v(:));
   elseif (isstr(v))
      str = v;
   elseif (isstruct(v))
      str = struct2str(v);
   else
      error('Unknown value format');
   end
end