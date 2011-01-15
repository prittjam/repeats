function primitive_key_list = cvdb_ins_vanishing_lines(conn, X, ...
                                                      img, name, tags)
    error(nargchk(4, 5, nargin));
    
    if (nargin < 4)
        name = {};
        tags = {}; 
    end 
    
    tags = cat(2,tags,{'line segments','end points'});
    
    for i=1:length(X)
        if (~isempty(X{i}))
            cvdb_ins_primitives(conn, X{i}, ...
                                imread(img), name, tags);
        end
    end
    