function tablename = cass_cql_gettablename(attribute,opt)
if ~exist('opt','var'), opt = struct(); end;
  tablename = 'data';
  if isfield(opt,'cf')
    % in this way it is used in /matlab/knnvocab/0_detect/processjob.m
    tablename = opt.cf;

    opt = rmfield(opt,'cf');
    if ~isempty(fieldnames(opt))
      warning('Additional options are not supported by cassandra CQL driver.');
    end
    return;
  end
  
  % In the rest of the scripts, the tablename is usually expressed as
  % 'tablename:somethingelse'
  
  rawKey = ':raw';
  rawPos = strfind(attribute,rawKey);
  if length(attribute) - rawPos + 1 == length(rawKey) % must be a suffix
    attribute = strrep(attribute,':raw',''); % Remove :raw tag from the string
  end
  
  if strcmp(attribute,'image')
    tablename = 'image';
    return;
  end
  
  colonPos = strfind(attribute,':');
  if colonPos > 0
    tablename = attribute(1:(colonPos-1));
  end
end