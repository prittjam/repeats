function m = scene_get_tc(dr1,dr2,cfg)
global conn

ind1 = regexpi(dr1.key,'[^:]*$','start');
prefix = dr1.key(1:ind1-1);
key1 = dr1.key(ind1:end);

ind2 = regexpi(dr2.key,'[^:]*$','start');
key2 = dr2.key(ind2:end);

if strcmpi(key1,key2)
    key3 = key1;
else
    key3 = cvdb_hash_xor(key1,key2);
end

dhash = [prefix cvdb_hash_xor(cfg.dhash,key3)];

[m,is_found] = cvdb_sel_tc(conn, ...
                           dr1.img_id, ...
                           dr2.img_id, ...
                           dhash);

if ~is_found
    m = scene_make_tc(dr1,dr2,cfg);
    cvdb_ins_tc(conn, ...
                dr1.img_id,dr2.img_id,dhash, ...
                m);
end