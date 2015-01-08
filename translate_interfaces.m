function iface = translate_interfaces(iface)
   iface = structfun(@(field) translate(field), iface ,'uniformoutput', false);
end

function f = translate(s)
   if isa(s, 'function_handle') || isa(s, 'double') || (isa(s, 'char') && s(1) == '/')
      f = s;
   else
      f = str2func(s);      
   end
end