function [mstr hstr] = struct2str(s)
   value = struct2cell(s);
   field = fieldnames(s);

   mstr = 'struct('; %matlab readable
   hstr = ''; %human readable
   for i = 1:numel(field)
      mstr = [mstr '''' field{i} ''', ' tostr(value{i})];
      hstr = [hstr field{i} '=' tostr(value{i})];
      if (i ~= numel(field))
         mstr = [mstr ','];
         hstr = [hstr ', '];
      end
   end
   mstr = [mstr ')'];

end

function str = tostr(v)
   if (isempty(v))
      str = '[]';
   elseif (isnumeric(v) || islogical(v))
      str = num2str(v);
   elseif (isstr(v))
      str = ['''' v ''''];
   elseif (isstruct(v))
      str = struct2str(v);
   else
      error('Cannot convert struct to string. Unknown value format');
   end
end