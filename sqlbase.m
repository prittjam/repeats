classdef sqlbase < handle
    properties
        conn;
        connh;
        cfg;
    end
    
    methods(Access=public)
        function this = sqlbase(file_name)
            this.connh = [];
            if nargin < 1
                file_name = 'zornsqldb.cfg';
            end

            if exist('zornsqldb.cfg','file')
                fid = fopen('zornsqldb.cfg');
                text = textscan(fid,'%s','Delimiter','\n');
                credentials = text{:};
                
                this.cfg.server_name = credentials{1};
                this.cfg.name = credentials{2};
                this.cfg.user = credentials{3};
                this.cfg.pass = credentials{4};
            end
        end

        function conn = open(this,varargin)
            this.cfg = helpers.vl_argparse(this.cfg,varargin{:});
            try
                [this.conn,this.connh] = ...
                    sqlbase.dbconn2(this.cfg.server_name, ...
                                    this.cfg.name, ...
                                    this.cfg.user, ...
                                    this.cfg.pass);
            catch exception
                warning(['Could not open database connection. Database will be ' ...
                         'unavailable']);
            end
        end
    end    
    
    methods(Static,Access=private)
        function [conn,connh] = dbconn2(server_name, name, user, pass)
            global DBCONNECTIONS;
            error(nargchk(3, 4, nargin, 'struct'));   
            if (nargin == 3), pass = ''; end

            if ~usejava('jvm')
                error([mfilename ' requires Java to run.']);
            end   

            % Create the database connection object
            jdbcString = sprintf('jdbc:mysql://%s/%s', server_name, name);
            jdbcDriver = 'com.mysql.jdbc.Driver';

            hash = [name user];
            hash_time = [name user 'time'];
            if (~isfield(DBCONNECTIONS, hash) || ~isa(DBCONNECTIONS.(hash), 'database')) %connection did not exist
                DBCONNECTIONS.(hash) = database(name, user, pass, jdbcDriver, jdbcString);
                DBCONNECTIONS.(hash_time) = now;
            elseif (~isconnection(DBCONNECTIONS.(hash))) %reconnect
                DBCONNECTIONS.(hash) = database(name, user, pass, jdbcDriver, jdbcString);
                DBCONNECTIONS.(hash_time) = now;
            end

            if (now - DBCONNECTIONS.(hash_time) > 20/24/60) %20 min
                try
                    close(DBCONNECTIONS.(hash));
                catch
                end
                DBCONNECTIONS.(hash) = database(name, user, pass, jdbcDriver, jdbcString);
                DBCONNECTIONS.(hash_time) = now;
                disp('DB connection refreshed.');
            end

            if (~isconnection(DBCONNECTIONS.(hash))) %final check
                error(get(DBCONNECTIONS.(hash), 'Message'));
            end

            DBCONNECTIONS.(hash_time) = now;
            conn = DBCONNECTIONS.(hash);
            connh = conn.Handle;
            connh.setAutoReconnect(true);
        end
    end
end