function desc_defs = desc_define_method(desc_defs, name, function_name, input, output)
try
    idx = length(desc_defs)+1;
catch
    desc_defs = struct;
    idx = 1;
end;

desc_defs(idx).name = name;
desc_defs(idx).fnname = function_name;
desc_defs(idx).input = input;
desc_defs(idx).output = output;