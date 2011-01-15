function [flatCell scoreList dotList]=flatten_nested_struct(S)

% Flatten a NESTED structure into a cell
%
% It's hard to describe it in simple words. 
% Before somebody send me good documentation suggestions, please take
% a look at the screenshots at
%
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=
% 18816&objectType=FILE
%
% Dependency:   flatNestedStructAccessList.m
%
% WARNING:      This program is basically a wrapper for flatStructAccessList,
%               so it comes with its limitations. In other words,
%               don't use it on nested structs with something like this
%
%                   a.b{3}.c = 1;
%               or
%
%                   p.q(4).r = 5;
%             
%               I don't know what's going to happen if you do so!
%
%               I'd appreciate if somebody can expand this to non-singleton
%               branches like x(1).y{2}.z
%
% flatCell:     The contents of input struct flattens into this cell
% dotList:      The struct operator that gives you the corresponding cell
% scoreList:    Replaces '.' in dotList by '_' so that you can
%               name variables automatically with the cell.
%
% Author:       Hoi Wong (wonghoi.ee@gmail.com)
% Date:         02/19/2008


    dotList = flat_nested_struct_access_list(S);
    scoreList = strrep(dotList, '.', '_');
    
    for k=1:length(dotList)
        flatCell{k,1} = eval( sprintf('S.%s', dotList{k}) );
    end
    