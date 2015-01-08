function [id_list names] = imagelist(dataset, from, to)
% FS_IMAGELIST - returns the list of images for a dataset
%
%   FS_IMAGELIST(DATASET, FROM, TO) returns a set of images of DATASET.
%   Optionally, the result can be limited using FROM, TO parameters (including
%   FROM and TO images of the result). Indexes are zero based, i.e. first result
%   is 0.
   %% hvocab - with this set we run experiments on hvocab. (5631312 images)
   %% flickr - vsetky obrazky z flickr databazy

   error(nargchk(1, 3, nargin));
   if nargin == 3
      limit = sprintf(' LIMIT %d, %d; ', from, to-from+1);
      count = to-from+1;
   else
      limit = '';
      count = 0;
   end

   conn = dbconn('flickr','reader');

   if ~count
      query_count = sprintf('SELECT count(*) FROM dataset_%s ORDER BY cid %s', dataset, limit);
      count = fetch(conn, query_count); count = count{1};
   end

   disp(['Number of images ' num2str(count) '...']);

   if nargin == 1
      from = 0;
      to = count-1;
   end

   id_list = [];
   names = [];
   step = 1000000;
   progressbar(0);
   for from1 = from:step:to-1

      to1 = min(from1+step-1, to);
      limit = sprintf(' LIMIT %d, %d; ', from1, to1-from1+1);

      if nargout < 2
         query = sprintf('SELECT cid FROM dataset_%s ORDER BY cid %s', dataset, limit);
         id_list_temp = fetch(conn, query);
         id_list = [id_list; id_list_temp];
      else
         query = sprintf('SELECT cid, name FROM dataset_%s ORDER BY cid %s', dataset, limit);
         res = fetch(conn, query);
         %id_list_temp = res(:,1);
         %names_temp = res(:,2);
         id_list = [id_list; res(:,1)];
         names = [names; res(:,2)];
      end
      progressbar(to1/to);
   end

end
