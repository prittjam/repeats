classdef imagedb < handle
    properties
        cass
    end

    methods
        function this = imagedb()
            this.cass = Cass();
        end
        
        function [] =  insert(this,table,img_id,key,data)
            this.cass.put(img_id,data,[table ':' key],[]); 
        end


        function [s,is_found] = select(this,table,img_id,cfg_key)
            s = [];
            is_found = false;

            %            try
                is_found = this.cass.check(img_id,[table ':' cfg_key], ...
                                                 []);
                if is_found
                    s = this.cass.get(img_id,[table ':' cfg_key],[]); 
                end
%            catch err
%                disp(err.message);
%            end
        end

        function [is_found] = check(this,table,img_id,cfg_key)
            is_found = this.cass.check(img_id,[table ':' cfg_key],[]);
        end

    end
end