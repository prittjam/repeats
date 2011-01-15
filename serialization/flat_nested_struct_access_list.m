function [flatCellString, isLeafNode]= flat_nested_struct_access_list(S, varargin)

% Create a string list of all possible struct access operators (e.g. x.y.z)
% from a nested structure (think of it as a tree view program, except that
% eval(..) the strings in the output display).
%
%
% It's hard to describe it in simple words. 
% Before somebody send me good documentation suggestions, please take
% a look at the screenshots at:
%
% http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=
% 18816&objectType=FILE
%
%
% Usage:    flatCellString = flatStructAccessList(structure)
%           Do NOT put in extra arguments/outputs! That's for recusion only
%
% Purpose:  For accessing (flattening) big nested struct automatically with
%           eval(..). Or it can serve a a tree view for nested structure.
%
% WARNING:  This program doesn't supported nested structs with 
%           non-signleton branches (except the leaf nodes). In other words,
%           don't use it on nested structs with something like this
%
%               a.b{3}.c = 1;
%           or
%
%               p.q(4).r = 5;
%             
%           I don't know what's going to happen if you do so!
%
%           I'd appreciate if somebody can expand this to vector branches,
%           like x(1).y{2}.z
%
% Author:      Hoi Wong (wonghoi.ee@gmail.com)
% Date:        02/19/2008


if( nargin==1 )
    flatCellString = [];
    parentStructFullName = '';
else
    flatCellString = varargin{1};
    parentStructFullName = varargin{2};
end


if( ~isstruct(S) )
    
    isLeafNode = true;
    % 'flatCellString' will pass through
    return;
    
else
    
    isLeafNode = false;
    
    branchNames = fieldnames(S);
    for k=1:size(branchNames,1)
        
        childStruct = S.(branchNames{k});    
        if( isempty(parentStructFullName) )
            childNodeFullName = branchNames{k};
        else
            childNodeFullName = [parentStructFullName, '.', branchNames{k}];
        end
        % NOTE: childNodeFullName become parentNodeFullName when recursed
        %       so don't combine them as self-update (=> wrong behavior)
        
        [flatCellString leafNodeStatus]= flat_nested_struct_access_list(childStruct, flatCellString, childNodeFullName);
        if( leafNodeStatus )
            % Add item to registry only when leaf node is reached
            flatCellString = [flatCellString; {childNodeFullName}];
        end
        
    end
    
end