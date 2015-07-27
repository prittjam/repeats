classdef DrCache < handle
    properties
        cid_cache
    end
        
    methods 
        function this = DrCache(cid_cache)
            this.cid_cache = cid_cache;
        end

        function [res,key_list] = extract(this,chain,img)



            if any(putit)
                this.cid_cache.put(chain(putit),res(putit));
            end
            
        end

    end
end