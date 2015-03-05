classdef ImageDb < handle
    properties
        cass
    end

    methods
        function this = ImageDb(varargin)
            this.cass = Cass(varargin{:});
        end
        
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
                        tmpurl = '/tmp/tmpimpng';
                    else
                        tmpurl = 'tmpimpng';
                    end
                    fid = fopen(tmpurl,'w');
                    fwrite(fid,filecontent);
                    fclose(fid);
                    img = imread(tmpurl);
                    delete(tmpurl);                    
                end
            end
        end
        
        function [] =  put(this,table,img_id,key,data)
            this.cass.put(img_id,data,[table ':' key],[]); 
        end

        function [s,is_found] = get(this,table,img_id,cfg_key)
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