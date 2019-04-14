classdef (Abstract) legtools 
    % LEGTOOLS is a MATLAB class definition providing the user with a set of
    % methods to modify existing Legend objects.
    %
    % This is an HG2 specific implementation and requires MATLAB R2014b or
    % newer.
    %
    % legtools methods:
    %     append   - Add one or more entries to the end of the legend
    %     permute  - Rearrange the legend entries
    %     remove   - Remove one or more legend entries
    %     adddummy - Add one or more entries to the legend for unsupported graphics objects
    %
    % NOTE:
    %      For MATLAB versions >= R2017a, the legend object's 'AutoUpdate'
    %      property must be set to 'off' before using this utility
    %
    % See also legend
    
    methods (Static)
        function append(lh, newStrings)
            % APPEND appends strings, newStrings, to the specified Legend
            % object, lh. newStrings can be a 1D character array or a 1D
            % cell array of strings. Character arrays are treated as a
            % single string. If multiple Legend objects are specified, only
            % the first will be modified.
            %
            % The legend will only be updated with the new strings if the
            % number of strings in the existing legend plus the number of
            % strings in newStrings is the same as the number of plots on
            % the associated axes object (e.g. if you have 2 lineseries and
            % 2 legend entries already no changes will be made).
            legtools.verchk()
            lh = legtools.handlecheck('append', lh);
            
            % Make sure newString exists & isn't empty
            if ~exist('newStrings', 'var') || isempty(newStrings)
                error('legtools:append:EmptyStringInput', ...
                      'No strings provided' ...
                      );
            end
            
            newStrings = legtools.strcheck('append', newStrings);
            
            legtools.autoupdatecheck(lh)
            
            % To make sure we target the right axes, pull the legend's
            % PlotChildren and get their parent axes object
            parentaxes = lh.PlotChildren(1).Parent;
            
            % Get line object handles
            plothandles = flipud(parentaxes.Children);  % Flip so order matches
            
            % Update legend with line object handles & new string array
            newlegendstr = [lh.String newStrings];  % Need to generate this before adding new plot objects
            
            % Use the union of the parent axes' Children and the legend
            % handle's PlotChildren to properly order the legend strings.
            % Union(A, B, 'Sorted') will return A concatenated with the
            % values of B not in A, so we have the handles associated with
            % the existing entries and then the remaining handles in the
            % order they are plotted.
            lh.PlotChildren = union(lh.PlotChildren, plothandles, 'stable');
            
            if numel(newlegendstr) > numel(lh.PlotChildren)
                % MATLAB automatically throws out the extra legend entries
                % if the number of strings to be added is larger than the
                % number of supported graphics objects that are children of
                % the parent axes. legend throws a warning in this case and
                % we should too
                warning('legtools:append:IgnoringExtraEntries', ...
                        'Ignoring extra legend entries');
            end
            lh.String = newlegendstr;
            
            if ~verLessThan('matlab', '9.2')
                % The addition of 'AutoUpdate' to legend in R2017a breaks
                % the functionality of append. With 'AutoUpdate' turned off
                % we can restore the functionality of legtools, but turning
                % it back on causes our appended legend entries to be
                % deleted. Clearing out the undocumented
                % 'PlotChildrenExcluded' legend property seems to prevent
                % this from occuring
                %
                % NOTE: This is untested in versions < R2017a
                lh.PlotChildrenExcluded = [];
            end
        end
        
        
        function permute(lh, order)
            % PERMUTE rearranges the entries of the specified Legend
            % object, lh, so they are then the order specified by the
            % vector order. order must be the same length as the number of
            % legend entries in lh. All elements of order must be unique,
            % real, positive, integer values.
            legtools.verchk()
            
            % Temporarily throw an error for MATLAB >= R2017a
            if ~verLessThan('matlab', '9.2')
                error('legtools:permute:NotImplementedError', ...
                      'legtools.permute is currently not functional in MATLAB >= R2017a', ...
                      )
            end
            
            if ~exist('order', 'var') || isempty(order)
                error('legtools:permute:EmptyOrderInput', ...
                      'No permute order provided' ...
                      );
            end
            
            lh = legtools.handlecheck('permute', lh);
            
            % Catch length & uniqueness issues with order, let MATLAB deal
            % with the rest.
            if numel(order) ~= numel(lh.String)
                error('legtools:permute:TooManyIndices', ...
                      'Number of values in order must match the number of legend strings' ...
                      );
            end
            
            if numel(unique(order)) < numel(lh.String)
                error('legtools:permute:NotEnoughUniqueIndices', ...
                      'order must contain enough unique indices to index all legend strings' ...
                      );
            end
            
            % Permute the legend data source(s) and string(s)
            % MATLAB has a listener on the PlotChildren so when their order
            % is modified the string order is changed with it
            lh.PlotChildren = lh.PlotChildren(order);
        end
        
        
        function remove(lh, remidx)
            % REMOVE removes the legend entries of the legend object, lh,
            % at the locations specified by remidx. All elements of remidx 
            % must be real, positive, integer values.
            %
            % If remidx specifies all the legend entries, the legend
            % object is deleted
            legtools.verchk()
            lh = legtools.handlecheck('remove', lh);

            % Temporarily throw an error for MATLAB >= R2017a
            if ~verLessThan('matlab', '9.2')
                error('legtools:remove:NotImplementedError', ...
                        'legtools.remove is currently not functional in MATLAB >= R2017a', ...
                        )
            end
            
            % Catch length issues, let MATLAB deal with the rest
            if numel(unique(remidx)) > numel(lh.String)
                error('legtools:remove:TooManyIndices', ...
                      'Number of unique values in remidx exceeds number of legend entries' ...
                      );
            end
            
            % Check remidx for indices greater than the number of legend
            % entries and throw them out.
            nlegendentries = numel(lh.PlotChildren);
            invalididxmask = remidx > nlegendentries;  % Logical test
            if any(invalididxmask)
                % If we have any invalid entries, remove them and throw a
                % warning
                remidx(invalididxmask) = [];
                warning('legtools:remove:InvalidIndex', ...
                        'Removal indices > %u have been ignored', nlegendentries ...
                       );
            end
            
            if numel(unique(remidx)) == numel(lh.String)
                delete(lh);
                warning('legtools:remove:LegendDeleted', ...
                        'All legend entries specified for removal, deleting Legend Object' ...
                        );
            else
                % Check legend entries to be removed for dummy lineseries 
                % objects and delete them
                objtodelete = [];
                count = 1;
                for ii = remidx
                    % Our dummy lineseries contain a single NaN YData entry
                    if length(lh.PlotChildren(ii).YData) == 1 && isnan(lh.PlotChildren(ii).YData)
                        % Deleting the graphics object here also deletes it
                        % from the legend, which screws up the one-liner
                        % plot children removal. Instead store the objects
                        % to be deleted and delete them after the legend is
                        % properly modified
                        objtodelete(count) = lh.PlotChildren(ii);
                        count = count + 1;
                    end
                end
                lh.PlotChildren(remidx) = [];
                delete(objtodelete);
            end
        end
        
        function adddummy(lh, newStrings, plotParams)
            % ADDDUMMY appends strings, newStrings, to the Legend Object, 
            % lh, for graphics objects that are not supported by legend.
            %
            % For a single dummy legend entry, plotParams is defined as a 
            % cell array of strings that follow MATLAB's PLOT syntax.
            % Entries can be either a LineSpec or a series of Name/Value
            % pairs. For multiple dummy legend entries, plotParams is 
            % defined as a cell array of cells where each top-level cell 
            % corresponds to a string in newStrings.
            %
            % ADDDUMMY adds a Chart Line Object to the parent axes of lh
            % consisting of a single NaN value so nothing is rendered in
            % the axes but it provides a valid object for legend to include
            %
            % LEGTOOLS.REMOVE will remove this Chart Line Object if its
            % legend entry is removed.

            legtools.verchk()
            lh = legtools.handlecheck('addummy', lh);
            
            % Make sure newStrings exists & isn't empty
            if ~exist('newStrings', 'var') || isempty(newStrings)
                error('legtools:adddummy:EmptyStringInput', ...
                      'No string provided' ...
                      );
            end
            
            newStrings = legtools.strcheck('adddummy', newStrings);
            
            legtools.autoupdatecheck(lh)
            
            % See if we have a character input for the single addition case
            % and put it into a cell. Double nest the cells so behavior is
            % consistent with a cell array of cells for multiple new dummy
            % entries
            if ischar(plotParams)
                plotParams = {cellstr(plotParams)};
            end

            % For the single dummy entry case, make sure each cell of
            % plotParams is a cell so behavior is sonsistent with a cell
            % array of cells for multiple new dummy entries
            if length(newStrings) == 1
                if ~iscell([plotParams{:}])
                    plotParams = {plotParams};
                end
            end
            
            parentaxes = lh.PlotChildren(1).Parent;
            
            washeld = ishold(parentaxes);  % Set a flag for previous hold state ofthe parent axes
            hold(parentaxes, 'on');
            for ii = 1:length(newStrings)
                plot(parentaxes, NaN, plotParams{ii}{:});  % Leave input validation up to plot
            end
            
            if ~washeld
                % If parentaxes wasn't previously held, turn hold back off
                hold(parentaxes, 'off');
            end
            legtools.append(lh, newStrings);  % Add legend entries
            
            if ~verLessThan('matlab', '9.2')
                % The addition of 'AutoUpdate' to legend in R2017a breaks
                % the functionality of append. With 'AutoUpdate' turned off
                % we can restore the functionality of legtools, but turning
                % it back on causes our appended legend entries to be
                % deleted. Clearing out the undocumented
                % 'PlotChildrenExcluded' legend property seems to prevent
                % this from occuring
                %
                % NOTE: This is untested in versions < R2017a
                lh.PlotChildrenExcluded = [];
            end
        end
        
    end
    
    methods (Static, Access = private)
        function verchk()
            % Throw error if we're not using R2014b or newer
            if verLessThan('matlab', '8.4')
                error('legtools:UnsupportedMATLABver', ...
                      'MATLAB releases prior to R2014b are not supported' ...
                      );
            end
        end
        
        function [lh] = handlecheck(src, lh)
            % Make sure lh exists and is a legend object
            if ~isa(lh, 'matlab.graphics.illustration.Legend')
                msgID = sprintf('legtools:%s:InvalidLegendHandle', src);
                error(msgID, 'Invalid legend handle provided');
            end
            
            % Pick first legend handle if more than one is passed
            if numel(lh) > 1
                msgID = sprintf('legtools:%s:TooManyLegends', src);
                warning(msgID, ...
                        '%u Legend objects specified, modifying the first one only', ...
                        numel(lh) ...
                        );
                lh = lh(1);
            end
        end
        
        function [newString] = strcheck(src, newString)
            % Validate the input strings
            if ischar(newString)
                % Input string is a character array, use cellstr to convert
                % to a cell array. See the documentation for cellstr for
                % its handling of 2D char arrays.
                newString = cellstr(newString);
            end
            
            if isa(newString, 'string')
                % MATLAB introduced the String data type in R2016b. To
                % avoid having to write separate behavior everywhere to
                % handle this, convert the String array to a Cell array
                newString = cellstr(newString);
            end
            
            % Check to see if we now have a cell array
            if ~iscell(newString)
                msgID = sprintf('legtools:%s:InvalidLegendString', src);
                
                if ~verLessThan('matlab', '9.1')
                    % String data type introduced in MATLAB R2016b so this
                    % trying to get its class in older versions will error
                    % out our error
                    error(msgID, ...
                          'Invalid Data Type Passed: %s\n\nData must be of type: ''%s'', ''%s'', or ''%s''', ...
                          class(newString), class(cell(1)), class(''), class("") ...
                          );
                else
                    % Error message for MATLAB versions older than R2016b
                    error(msgID, ...
                          'Invalid Data Type Passed: %s\n\nData must be of type: ''%s'' or ''%s''', ...
                          class(newString), class(cell(1)), class('') ...
                          );
                end
            end
            
            % Check shape of newStrings and make sure it's 1D
            if size(newString, 1) > 1
                newString = reshape(newString', 1, []);
            end
            
            % Check to make sure we're only passing strings
            for ii = 1:length(newString)
                % Check for characters, let MATLAB handle errors for data
                % types not compatible with num2str
                if ~ischar(newString{ii})
                    msgID = sprintf('legtools:%s:ConvertingInvalidLegendString', src);
                    warning(msgID, ...
                            'Input legend ''string'' is of type %s, converting to %s', ...
                            class(newString{ii}), class('') ...
                            );
                    newString{ii} = num2str(newString{ii});
                end
            end
        end
        
        function autoupdatecheck(lh)       
            % If we're using R2017a or newer, we need to make sure that 
            % 'AutoUpdate' is off
            if ~verLessThan('matlab', '9.2')
                if ~strcmp(lh.AutoUpdate, 'off')
                    lh.AutoUpdate = 'off';
                    warning('legtools:autoupdatecheck:AutoUpdateNotOff', ...
                            'Input legend object''s ''AutoUpdate'' property has been set to ''off''')
                end
            end
        end
    end
end