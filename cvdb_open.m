function conn2 = cvdb_open(server_name, db_name, user_name, password)
connh = [];
try
    [conn connh] = dbconn2(server_name, db_name, user_name,  password);
catch exception
    warning(['Could not open database connection. Database will be ' ...
             'unavailable']);
end

conn2.Handle = connh;

function [conn connh] = dbconn2(server_name, db_name, user, pass)
   global DBCONNECTIONS;
   error(nargchk(2, 3, nargin, 'struct'));   
   if (nargin == 2), pass = ''; end

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
