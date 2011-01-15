function [cfghash json] = cfg2hash(struct_to_save)

   json = mat2json(struct_to_save);
   cfghash = hash(json, 'md5');