function res = reflect(res,width)
if ~iscell(res)
    res = {{res}};
elseif ~iscell(res{1})
    for i = 1:numel(res)
        res{i} = {res{i}};
    end
end

for k = 1:numel(res)
    if isfield(res{k}{end},'affpt')
        m = 0; 
        if isfield(res{k}{1},'haff') && res{k}{1}.haff
            m = 1;
        end
        RF = [-1 0 width-m; 0 1 0; 0 0 1];
        res{k}{end}.affpt = LAF.apply_T_to_affpt(res{k}{end}.affpt,RF);
        [res{k}{end}.affpt.reflected] = deal(true);
    end
end
