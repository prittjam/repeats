classdef imagedb < handle
    properties
        % === mandatory part (in the most cases stays unchanged) === %
        verbose                = 0;
        master_isfinished      = false;
        min_chunk_size         = 10;
        mypath                 = fileparts(mfilename('fullpath'));
        % === end of mandatory part === %

        % database for storing configurations
%        confdb.schema = 'config';
%        confdb.user   = 'perdom1';
%        confdb.pass   = '';

        % configure data access
        imagedb_cluster = 'cmpgrid_cassandra';

        storage = struct('check', 'cass_cql_imagecheck', ...
                         'get', 'cass_cql_imageget', ...
                         'put', 'cass_cql_imageput', ...
                         'remove', 'cass_cql_imageremove', ...
                         'tostr', 'item2str', ...
                         'list','imagelist');
    end

    methods
        function this = imagedb()
            this.storage = translate_interfaces(this.storage);
            this.storage
            this.storage.retry_count = 25;
            this.storage.db_root = '/mnt/fry';
        end

        function [] =  insert(this,table,img_id,key,data)
            this.storage.put(img_id,data,[table ':' key],[]); 
        end


        function [s,is_found] = select(this,table,img_id,cfg_key)
            s = [];
            is_found = false;

            try
                is_found = this.storage.check(img_id,[table ':' cfg_key], ...
                                                 []);
                if is_found
                    s = this.storage.get(img_id,[table ':' cfg_key],[]); 
                end
            catch err
                disp(err.message);
            end
        end

        function [is_found] = check(this,table,img_id,cfg_key)
            is_found = this.storage.check(img_id,[table ':' cfg_key],[]);
        end

    end
end