function [fqname_list,key_list] = get_fqname(varargin)
fqname_list = cell(1,numel(varargin{1}));
for k = 1:numel(varargin{1})
    hash_list = {};
    for k2 = 1:numel(varargin)-1
        fqname_list{k} = cat(2,fqname_list{k}, ...
                              [class(varargin{k2}(k)) ':']);
        hash_list{k2} = dr.dr_cfg.make_key(varargin{k2}(k));
    end    
    fqname_list{k} = cat(2,fqname_list{k},class(varargin{numel(varargin)}(k)));
    hash_list{numel(varargin)} = dr.dr_cfg.make_key(varargin{numel(varargin)}(k));
    key_list{k} = cvdb_hash_xor(hash_list);
end

fqname_list{1}
