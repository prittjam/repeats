function res = desc_describe(desc_defs,descriptors,dr,img)
% iterate through descriptors storages
outputs = desc_get_output(desc_defs,descriptors);
method = desc_get_methods(desc_defs,descriptors);
for k = 1:numel(dr)
    msg(1, 'Generating ''%s'' desc. from ''%s'' (%s)\n', ...
        upper(outputs{k}),dr{k}.name,img.url);
    t = cputime;

    res{k} = feval(['desc_' method{k}],desc_defs,descriptors(k),img,dr{k});
    res{k}.time = cputime-t;
end