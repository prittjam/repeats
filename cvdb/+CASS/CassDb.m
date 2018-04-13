classdef CassDb < handle
    properties
        cass
    end

    methods (Static)
        function obj = getObj( renew, varargin ) 
            if nargin == 0
                renew = false;
            end         
            persistent localObjCassDb;
            if isempty(localObjCassDb) || ~isvalid(localObjCassDb) || renew
                localObjCassDb = CASS.CassDb(varargin{:});
            end
            obj = localObjCassDb;
        end
    end 

    methods (Access = private)
        function this = CassDb(varargin)
            this.cass = CASS.Cass(varargin{:});
        end
    end

    methods
        function cid = put_img(this,url)
            filecontents = get_native_img(url);
            cid = HASH.hash(filecontents,'MD5');
            this.put('image',cid,'raw',filecontents);
        end
        
        function img = get_img(this,cid)
            img = [];
            has_img = this.check('image',cid,'raw');
            if has_img
                filecontent = this.get('image',cid,'raw');
                try
                    img = readim(filecontent);
                catch
                    if exist('/tmp','dir') == 7
                        tmpurl = ['/tmp/tmpimpng' cid];
                    else
                        tmpurl = ['tmpimpng' cid];
                    end
                    fid = fopen(tmpurl,'w');
                    fwrite(fid,filecontent);
                    fclose(fid);
                    img = imread(tmpurl);
                    delete(tmpurl);                    
                end
            end
        end
        
        function [] =  put(this,table,cid,key,data)
            this.cass.put(cid,data,[table ':' key],[]); 
        end

        function [s,is_found] = get(this,table,cid,cfg_key)
            s = [];
            is_found = false;

            %            try
                is_found = this.cass.check(cid,[table ':' cfg_key], ...
                                                 []);
                if is_found
                    s = this.cass.get(cid,[table ':' cfg_key],[]); 
                end
%            catch err
%                disp(err.message);
%            end
        end

        function [is_found] = check(this,table,cid,cfg_key)
            is_found = this.cass.check(cid,[table ':' cfg_key],[]);
        end

    end
end