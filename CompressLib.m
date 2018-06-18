% CompressLib.m
%--------------------------------------------------------------------------
% This Matlab class contains only static methods.
% These methods will compress matlab variables in java GZIP functions.
% Matrices, strings, structures, and cell arrays are supported. Matlab
% objects are also supported provided they implement a "toByteArray" method
% and a constructor of the form:
%          obj = constructor(byteArray,'PackedBytes')
%
% Usage:
%   x = % some matlab variable,
%       % can be a struct, cell-array,
%       % matrix, or object (if object conforms to certain standards)
%
%   cx = CompressLib.compress(x); % cx is a byte-array which contains
%                                 % compressed version of x
%
%   x2 = CompressLib.decompress(cx); %x2 is now a copy of x
%
%
% The methods CompressLib.packBytes and CompressLib.unpackBytes are also
% available.  These methods may be used to make Matlab classes compliant
% for the compression routines. See "packableObject.m" for an example
% Matlab class which is compliant with CompressLib.
%
% Use CompressLib.test to run a series of tests for functionality of this
% class.
%
% See also CompressLib.decompress  CompressLib.compress  packableObject
%          CompressLib.unpackBytes CompressLib.packBytes CompressLib.test
%
% Original Author: Jesse Hopkins
%
% $Author: jhopkin $
% $Date: 2009/10/29 20:24:59 $
% $Name:  $
% $Revision: 1.5 $
%--------------------------------------------------------------------------

classdef CompressLib
	methods(Static = true)

		function out = decompress(compressedData)
% CompressLib.decompress
%--------------------------------------------------------------------------
% out = CompressLib.decompress(byteArray)
%
% Function will decompress "byteArray" (created by CompressLib.compress).
% "byteArray" must be a 1-D array of bytes (uint8).
%
% Output will be the same class and dimension as original.
%
% See also CompressLib.compress    CompressLib.test      CompressLib
%          CompressLib.unpackBytes CompressLib.packBytes packableObject
%--------------------------------------------------------------------------

			import com.mathworks.mlwidgets.io.InterruptibleStreamCopier

			% if ~strcmpi(class(byteArray),'uint8') || ndims(byteArray) > 2 || min(size(byteArray) ~= 1)
			% 	error('Input must be a 1-D array of uint8');
			% end

			% %------Decompress byte-array "byteArray" to "byteData" using java methods------
			% a=java.io.ByteArrayInputStream(byteArray);
			% b=java.util.zip.GZIPInputStream(a);
			% isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
			% c = java.io.ByteArrayOutputStream;
			% isc.copyStream(b,c);
			% byteData = typecast(c.toByteArray,'uint8');
			%----------------------------------------------------------------------

			if isstruct(compressedData) && ~isfield(compressedData, 'compressed') && ~isequal(compressedData.compressed, 'GZIP')
                error('Input must be a compression structure.');
            end

			% Reserve memory
			byteData = zeros(compressedData.UncompressedSize, 1, 'uint8');

			% Decompress data in chunks
			for Iter=1:length(compressedData.Data)
			%------Decompress byte-array "byteArray" to "byteData" using java methods------
				a=java.io.ByteArrayInputStream(compressedData.Data{Iter});
				b=java.util.zip.GZIPInputStream(a);
				isc = InterruptibleStreamCopier.getInterruptibleStreamCopier;
				c = java.io.ByteArrayOutputStream;
				isc.copyStream(b,c);
				byteData((Iter-1)*compressedData.BlockSize+1:min(Iter*compressedData.BlockSize, length(byteData))) = typecast(c.toByteArray,'uint8');
			%----------------------------------------------------------------------
			end 

			%now interpret the decompressed byte array back to matlab types
			out = CompressLib.unpackBytes(byteData);
		end

		function compressedData = compress(in)
% CompressLib.compress
%--------------------------------------------------------------------------
% byteArray = CompressLib.compress(in)
%
% This method will compress input using GZIP java libraries.  Numeric
% matricies, structures, cell-arrays, and character strings are supported.
%
% Objects are also supported provided they implement a "toByteArray" method
% and a constructor of the form:
%         obj = constructor(byteArray,'PackedBytes')
%
% Outputs an array of type uint8.  Use CompressLib.decomress to decompress
% to original data.
%
% See also CompressLib.decompress  CompressLib.test      CompressLib
%          CompressLib.unpackBytes CompressLib.packBytes packableObject
%--------------------------------------------------------------------------

			%pack the input variable to an array of bytes
			byteData = CompressLib.packBytes(in);

			% %-------compress the array of bytes using java GZIP--------------------
			% f=java.io.ByteArrayOutputStream();
			% g=java.util.zip.GZIPOutputStream(f);
			% g.write(byteData);
			% g.close;
			% byteArray=typecast(f.toByteArray,'uint8');
			% f.close;
			%----------------------------------------------------------------------
		
            % Compress data in chunks
            compressedData.compressed = 'GZIP';
            compressedData.BlockSize = 5*1024^2; % Make 5 MiB chunks
            compressedData.UncompressedSize = length(byteData);
            compressedData.Data = cell(ceil(compressedData.UncompressedSize/compressedData.BlockSize), 1);
            for Iter = 1:length(compressedData.Data)
                %-------compress the array of bytes using java GZIP--------------------
                f=java.io.ByteArrayOutputStream();
                g=java.util.zip.GZIPOutputStream(f);
                g.write(byteData((Iter-1)*compressedData.BlockSize+1:min(Iter*compressedData.BlockSize, compressedData.UncompressedSize)));
                g.close;
                compressedData.Data{Iter}=typecast(f.toByteArray,'uint8');
                f.close;
                %----------------------------------------------------------------------
            end
		end

		function NumBytes = byteSize(in)
			s = whos('in');
			NumBytes = s.bytes;
		end

		function is = isCompressed(in)
			is = isstruct(in);
			if is
				fields = fieldnames(in);
				is = strcmp([fields{:}], ...
					'compressedBlockSizeUncompressedSizeData');
			end
		end

		function out = unpackBytes(byteData)
% CompressLib.unpackBytes
%--------------------------------------------------------------------------
% out = CompressLib.unpackBytes(byteArray)
%
% Function will unpack "byteArray" (created by CompressLib.packBytes)
% to its original Matlab datatype.
%
% Matrices, strings, structures, and cell arrays are supported. Matlab
% objects are also supported provided they implement a constructor
% of the form:
%          obj = constructor(byteArray,'PackedBytes')
%
% See "packableObject.m" for an example Matlab class that is compliant.
%
% See also CompressLib.decompress  CompressLib.compress CompressLib
%          CompressLib.packBytes   CompressLib.test     packableObject
%--------------------------------------------------------------------------

			out = CompressLib.unpackBytesRecurse(byteData,1);
		end

		function [byteData] = packBytes(in)
% CompressLib.packBytes
%--------------------------------------------------------------------------
% byteArray = CompressLib.packBytes(in)
%
% This function will convert "in" to a byte-array representation.  Numeric
% matricies, structures, cell-arrays, and character strings are supported.
% Use CompressLib.unpackBytes to convert back to original Matlab
% representation.
%
% Objects are also supported provided they implement a "toByteArray"
% method. See "packableObject.m" for an example Matlab class that
% is compliant.
%
% See also CompressLib.decompress  CompressLib.compress CompressLib
%          CompressLib.unpackBytes CompressLib.test     packableObject
%--------------------------------------------------------------------------



			%pre-allocate bytedata
			tmp = whos('in');
			byteData = zeros(tmp.bytes + 200,1,'uint8');
			curOffset = 1;

			[byteData curOffset] = CompressLib.packBytesRecurse(in,byteData,curOffset);

			%chop byteData to proper size
			byteData = byteData(1:curOffset-1);
		end

		function pass = test
% CompressLib.test
%--------------------------------------------------------------------------
% pass = CompressLib.test()
%
% Use this method to test the functionality of the entire CompressLib class.
% Will perform a suite of tests and report results. Outputs "true" if all
% tests passed, outputs false if any test fails.
%
% (A test is declared "passed" if the isequal() returns true for the original
% data and decompressed data)
%
% See also CompressLib.decompress  CompressLib.compress    CompressLib
%          CompressLib.packBytes   CompressLib.unpackBytes packableObject
%--------------------------------------------------------------------------
			i = 0;

			test = struct('data',{},'desc',{},'result',{});
			numericClasses = {'double','single','uint64','uint32','uint16','uint8','int64','int32','int16','int8'};
			%----------TEST 1-D NUMERIC CLASSES----------------------------
			for classCnt = 1:length(numericClasses)
				i = i+1;
				test(i).data = ones(1,1000,numericClasses{classCnt});
				test(i).desc = sprintf('ones(1,1000,%s',numericClasses{classCnt});
			end
			%--------------------------------------------------------------

			%----------TEST 2-D NUMERIC CLASSES----------------------------
			for classCnt = 1:length(numericClasses)
				i = i+1;
				test(i).data = ones(50,100,numericClasses{classCnt});
				test(i).desc = sprintf('ones(50,100,%s',numericClasses{classCnt});
			end
			%--------------------------------------------------------------

			%----------TEST 3-D NUMERIC CLASSES----------------------------
			for classCnt = 1:length(numericClasses)
				i = i+1;
				test(i).data = ones(50,100,20,numericClasses{classCnt});
				test(i).desc = sprintf('ones(50,100,20,%s',numericClasses{classCnt});
			end
			%--------------------------------------------------------------

			%---------TEST 1D LOGICALS-------------------------------------
			i = i+1;
			test(i).data = logical(rand(1,1000) > 0.5);
			test(i).desc = '1-D Logical';
			%--------------------------------------------------------------

			%---------TEST 2D LOGICALS-------------------------------------
			i = i+1;
			test(i).data = logical(reshape(test(i-1).data,100,10));
			test(i).desc = '2-D Logical';
			%--------------------------------------------------------------

			%---------TEST 3D LOGICALS-------------------------------------
			i = i+1;
			test(i).data = logical(reshape(test(i-2).data,5,2,100));
			test(i).desc = '3-D Logical';
			%--------------------------------------------------------------

			%---------TEST 1-D Char----------------------------------------
			i = i+1;
			test(i).data = 'I am a string, please compress me!!!!!!!';
			test(i).desc = '1-D char';
			%--------------------------------------------------------------

			%---------TEST 2-D Char----------------------------------------
			i = i+1;
			test(i).data = reshape(test(i-1).data,2,20);
			test(i).desc = '2-D char';
			%--------------------------------------------------------------

			%---------TEST 3-D Char----------------------------------------
			i = i+1;
			test(i).data =  reshape(test(i-2).data,2,5,4);
			test(i).desc = '3-D char';
			%--------------------------------------------------------------

			%---------TEST CHAR CELL---------------------------------------
			i = i+1;
			charcell = {'I am string1','I am string2','I am string3', ...
				        'I am a string of another dimension','Blah blah blah'};
			test(i).data = charcell;
			test(i).desc = '1-D cell of strings';
			%--------------------------------------------------------------

			%---------TEST MIXED CELLS-------------------------------------
			mixedcell = {'I am a string','I am another string',[4 5 6 7],uint8([9 10 11])};
			i = i+1;
			test(i).data = mixedcell;
			test(i).desc = 'Cell Array of Mixed Data Types';
			%--------------------------------------------------------------

			%---------TEST SUB CELLS---------------------------------------
			subcell = {'I am a string','I am another string',mixedcell,charcell};
			i = i+1;
			test(i).data = subcell;
			test(i).desc = 'Cell containing sub-cells';
			%--------------------------------------------------------------

			%-------TEST MULTI-DIM SUB CELLS-------------------------------
			multidimsubcell = {'I am a string','I am another string',mixedcell,charcell ...
				               subcell        , uint16([5 2  65535]),[345.34 3],[4.234 5.630;4.2 10e20]};
			i = i+1;
			test(i).data = multidimsubcell;
			test(i).desc = 'Multi-dimensional cell containing sub-cells';
			%--------------------------------------------------------------

			%-----------TEST STRUCT----------------------------------------
			i = i+1;
			teststruct.field1 = rand(1,10);
			teststruct.field2 = {'abc','def',[4 5 6],uint8([9 10 11])};
			teststruct.field3 = multidimsubcell;
			test(i).data = teststruct;
			test(i).desc = 'Single Structure';
			%--------------------------------------------------------------

			%-----------TEST 1-D STRUCT------------------------------------
			i = i+1;
			struct1d = repmat(teststruct,100,1);
			test(i).data = struct1d;
			test(i).desc = '1-D Structure Array';
			%--------------------------------------------------------------

			%-----------TEST 2-D STRUCT------------------------------------
			i = i+1;
			test(i).data = reshape(struct1d,50,2);
			test(i).desc = '2-D Structure Array';
			%--------------------------------------------------------------

			%-----------TEST 3-D STRUCT------------------------------------
			i = i+1;
			test(i).data = reshape(struct1d,5,10,2);
			test(i).desc = '3-D Structure Array';
			%--------------------------------------------------------------

			%-----------TEST 1-D STRUCT w/ substructs and cells------------
			i = i+1;
			substruct = struct1d;
			substruct(3).field2 = struct1d;
			substruct(4).field3 = multidimsubcell;
			substruct(5).field1 = {multidimsubcell{:},substruct};
			test(i).data = substruct;
			test(i).desc = '1-D Structure w/ substructs and cells';
			%--------------------------------------------------------------

			%-----------TEST 3-D STRUCT------------------------------------
			i = i+1;
			test(i).data = reshape(substruct,50,2);
			test(i).desc = '3-D Structure Array w/ substructs and cells';
			%--------------------------------------------------------------

			%-----------TEST 3-D STRUCT------------------------------------
			i = i+1;
			test(i).data = reshape(substruct,5,10,2);
			test(i).desc = '3-D Structure Array w/ substructs and cells';
			%--------------------------------------------------------------

			%--------TEST an OBJECT----------------------------------------
			i = i+1;
			test(i).data = packableObject;
			test(i).desc = 'A single object';
			%--------------------------------------------------------------

			%-----TEST array of OBJECTS------------------------------------
			i = i+1;
			test(i).data = repmat(test(i-1).data,1,100);
			test(i).desc = '1-D Object Array';
			%--------------------------------------------------------------

			%-----TEST 2-D array of OBJECTS--------------------------------
			i = i+1;
			test(i).data = reshape(test(i-1).data,50,2);
			test(i).desc = '2-D Object Array';
			%--------------------------------------------------------------

			%-----TEST 3-D array of OBJECTS--------------------------------
			i = i+1;
			test(i).data = reshape(test(i-2).data,10,5,2);
			test(i).desc = '3-D Object Array';
			%--------------------------------------------------------------

			%-----TEST Structure containing OBJECTS--------------------------------
			i = i+1;
			structwobject = struct1d;
			structwobject(1).field1 = test(i-1).data;
			test(i).data = structwobject;
			test(i).desc = 'Structure Containing Objects (among other things)';
			%--------------------------------------------------------------

			%--------TEST BIG CELL ARRAY-----------------------------------
			test(i).data = num2cell(rand(100,500));
			test(i).desc = 'Big cell matrix: num2cell(rand(100,500))';
			%--------------------------------------------------------------

			%perform tests
			for j = 1:length(test)
				[test(j).result totalTime] = CompressLib.dotest(test(j).data,test(j).desc,j);
			end


			%print summary
			results = cell2mat({test(:).result});
			failedTests = find(results == 0);
			if isempty(failedTests)
				passStr = 'Passed all tests!';
			else
				passStr = 'Failed';
			end

			fprintf('\n\n=======SUMMARY===================');
			fprintf('\nResult: %s',passStr);
			fprintf('\nTotal time in compress/decompress: %f sec',totalTime);
			if ~isempty(failedTests)
			fprintf('\nFailed Tests: \n%d',failedTests);
			end
			fprintf('\n=================================\n');

			%set output variable
			pass = isempty(failedTests);
		end
	end

	methods(Static = true,Hidden = true)
		function out = classStr2EnumVal(classStr)
			switch classStr
				case 'double'
					out = 1;
				case 'single'
					out = 2;
				case 'logical'
					out = 3;
				case 'char'
					out = 4;
				case 'int8'
					out = 5;
				case 'uint8'
					out = 6;
				case 'int16'
					out = 7;
				case 'uint16'
					out = 8;
				case 'int32'
					out = 9;
				case 'uint32'
					out = 10;
				case 'int64'
					out = 11;
				case 'uint64'
					out = 12;
				case 'struct'
					out = 13;
				case 'cell'
					out = 14;
				otherwise
					out = 0;
			end
		end

		function byteData = conditionBuffer(byteData,curOffset,writeLength)
			%this function exists to make sure that the byteData array
			%is long enough to store "writeLength" more bytes based on
			%"curOffset" in the array.
			if length(byteData) < curOffset + writeLength
				extraLengthNeeded = curOffset + writeLength - length(byteData);
				extraLengthNeeded = extraLengthNeeded + 100; %add 100 extra bytes
				disp(['CompressLib.packBytes is allocating ' num2str(extraLengthNeeded) ' more bytes!']);
				byteData = [byteData;zeros(extraLengthNeeded,1,'uint8')];
			end
		end

		function [pass totalTimeOut] = dotest(x,desc,testnum)
			persistent totalTime;
			if isempty(totalTime) || testnum == 1
				totalTime = 0;
			end

			tic;
			cx = CompressLib.compress(x);
			compressTime = toc;
			tic
			x2 = CompressLib.decompress(cx);
			decompressTime = toc;
			pass = isequal(x,x2);
			if pass
				passStr = 'pass';
			else
				passStr = 'FAIL';
			end


			xinfo  = whos('x');
			cxinfo = whos('cx');
			x2info = whos('x2');

			fprintf('\n\nTest %d: %s',testnum,passStr);
			fprintf('\n%s',desc);
			fprintf('\n----------------');
			fprintf('\nInput Class     : %s',xinfo.class);
			fprintf('\nInput Dim       : %s',num2str(xinfo.size));
			fprintf('\nInput Size      : %d bytes',xinfo.bytes);
			fprintf('\nCompress Size   : %d',cxinfo.bytes);
			fprintf('\nBytes Saved     : %d',xinfo.bytes-cxinfo.bytes);
			fprintf('\nCompress Ratio  : %2.1f%%',100*(xinfo.bytes-cxinfo.bytes)/xinfo.bytes);
			fprintf('\nOutput Size     : %d',x2info.bytes);
			fprintf('\nOutput Size diff: %d',x2info.bytes - xinfo.bytes);
			fprintf('\nCompress Time   : %f sec',compressTime);
			fprintf('\nDecompress Time : %f sec',decompressTime);



			totalTime = totalTime + compressTime + decompressTime;
			totalTimeOut = totalTime;

		end

		function [byteData curOffset] = packBytesRecurse(in,byteData,curOffset)
			%matrix data
			%header = [type  ndims  dim1  dim2    ...     DATA
			%          uint8 uint8 uint32 uint32 uint32   uint8[]
			%
			%struct data
			%header = [type         ndims  dim1    dim2    ...    numfields  | field1len  Fieldname    | field2len Fieldname | ... | Struct(1).fieldname{1} DATA  | Struct(1).fieldname{2} DATA | ... | Struct(2).filename{1} DATA |
			%          13(uint8) uint8  uint32  uint32  uint32     uint32    |  uint8       uint8[]    | uint8      uint8[]  | ... |                              |                             | ... |                            |
			%
			%cell data
			%header = [type        ndims  dim1  dim2    ...    | DATA{1}  | DATA{2} |
			%          14 (uint8)  uint8 uint32 uint32 uint32  |          |         |
			%
			%user-defined class
			%header = [type  ndims  dim1  dim2    ...   classNameLen  className    | datasize DATA(1)  | ... |
			%          0     uint8 uint32 uint32 uint32   uint8         uint8[]    | uint32    uint8[] | ... |

			classEnumVal2Str = { 'double';
			                 'single';
			                 'logical';
			                 'char';
			                 'int8';
			                 'uint8';
			                 'int16';
			                 'uint16';
			                 'int32';
			                 'uint32';
			                 'int64';
			                 'uint64';
			                 'struct';
			                 'cell'};
			getSizeFromClassEnum = [8;  % double
                                4;  % single
                                1;  % logical
                                1;  % char8
                                1;  % int8
                                1;  % uint8
                                2;  % int16
                                2;  % uint16
                                4;  % int32
                                4;  % uint32
                                8;  % int64
                                8]; % uint64
							
			inSize = size(in);
			inClass = class(in);

			%-----------------GET THE CLASS TYPE-----------------------------------
			inClassEnum = CompressLib.classStr2EnumVal(inClass);


			if inClassEnum == 0
				%this is some other class.  See if it has a "to byte array" method
				if ~ismethod(inClass,'toByteArray')
					error(['"' inClass '" is not supported for compression! (A class must implement method "toByteArray" in order to be compressed']);
				else
					inClassEnum = 0;
				end
			end

			%convert to unsigned int.
			inClassEnum = uint8(inClassEnum);

			%----------------------------------------------------------------------

			%-----Format the size--------------------------------------------------
			ndims_double = length(inSize);
			if ndims_double > 255
				error('To many dimensions, must have (ndims must be < 255)');
			else
				ndims = uint8(ndims_double);
				if max(inSize) >=4294967295
					error('Maximum dimension must be less than 4294967295!');
				else
					inSize = uint32(inSize);
				end
			end
			%----------------------------------------------------------------------


			%If the class type is logical or char, then convert to uint8
			if inClassEnum == 3 || inClassEnum == 4
				in=uint8(in);
			end

			if inClassEnum == 0
				%user-defined class
				%header = [type  ndims  dim1  dim2    ...   classNameLen  className    | datasize DATA(1)  | ... |
				%          14    uint8 uint32 uint32 uint32   uint8         uint8[]    | uint32    uint8[] | ... |
				writeLength = 3 + ndims_double*4 + length(inClass);
				byteData = CompressLib.conditionBuffer(byteData,curOffset,writeLength);
				                                                    %type   %ndims    %dim1 ... dimn
				byteData(curOffset:curOffset + writeLength-1) = [inClassEnum ndims typecast(inSize,'uint8') uint8(length(inClass)) uint8(inClass)];
				curOffset = curOffset + writeLength;

				in = in(:);
				for i = 1:length(in)
					objectByteArray = toByteArray(in(i));
					if ~strcmp(class(objectByteArray),'uint8')
						error('object method "toByteArray" did not return array of uint8!');
					end

					objectLen = length(objectByteArray);

					if objectLen > 4294967295
						error('object byte array length must be less than 4294967295!');
					end

					if length(inClass) > 255
						error('Class name must be less than 255!');
					end

					writeLength = 4 + numel(objectByteArray);
					byteData = CompressLib.conditionBuffer(byteData,curOffset,writeLength);
					byteData(curOffset:curOffset+writeLength-1) = [typecast(uint32(objectLen),'uint8') objectByteArray(:)' ];
					curOffset = curOffset + writeLength;
				end

			elseif inClassEnum == 13
				%we have a struct
				structfields = fieldnames(in);

				writeLength = 6 + ndims_double*4;
				byteData = CompressLib.conditionBuffer(byteData,curOffset,writeLength);
				                                                %type     %ndims    %dim1 ... dimn                %numfields
				byteData(curOffset:curOffset+writeLength-1) = [inClassEnum ndims typecast(inSize,'uint8') typecast(uint32(length(structfields)),'uint8')];
				curOffset = curOffset + writeLength;

				for i = 1:length(structfields)
					%add the fields
					if length(structfields(i)) > 255
						error('Fieldname length cannot exceed 255!');
					end

					%add fieldData
					writeLength = 1 + length(structfields{i});
					byteData = CompressLib.conditionBuffer(byteData,curOffset,writeLength);
					byteData(curOffset:curOffset+writeLength-1) = [uint8(length(structfields{i})) uint8(structfields{i})];
					curOffset = curOffset + writeLength;
				end

				%now add data
				in = in(:);
				for i = 1:length(in)
					for j = 1:length(structfields)
						[byteData curOffset] = CompressLib.packBytesRecurse(in(i).(structfields{j}),byteData,curOffset);
					end
				end
			elseif inClassEnum == 14
				%we have a cell!
				%cell data
				%header = [type  ndims  dim1  dim2    ...    | DATA{1}  | DATA{2} |
				%          14    uint8 uint32 uint32 uint32  |          |         |
				writeLength = 2 + ndims_double*4;
				byteData = CompressLib.conditionBuffer(byteData,curOffset,writeLength);
				                                                  %type     %ndims    %dim1 ... dimn
				byteData(curOffset:curOffset + writeLength-1) = [inClassEnum ndims typecast(inSize,'uint8') ];
				curOffset = curOffset + writeLength;

				in = in(:);
				for i = 1:length(in)
					[byteData curOffset] = CompressLib.packBytesRecurse(in{i},byteData,curOffset);
				end
			else
				in = in(:)';
				writeLength = 2 + ndims_double*4 + getSizeFromClassEnum(inClassEnum)*numel(in);
				byteData = CompressLib.conditionBuffer(byteData,curOffset,writeLength);
				byteData(curOffset:curOffset+writeLength-1) = [inClassEnum typecast(ndims,'uint8') typecast(inSize,'uint8') typecast(in,'uint8')];
				curOffset = curOffset + writeLength;
			end
		end

		function [data curOffset] = unpackBytesRecurse(byteData,curOffset)
			classEnumVal2Str = { 'double';
			                 'single';
			                 'logical';
			                 'char';
			                 'int8';
			                 'uint8';
			                 'int16';
			                 'uint16';
			                 'int32';
			                 'uint32';
			                 'int64';
			                 'uint64';
			                 'struct';
			                 'cell'};
						 
			getSizeFromClassEnum = [8;  % double
                                4;  % single
                                1;  % logical
                                1;  % char8
                                1;  % int8
                                1;  % uint8
                                2;  % int16
                                2;  % uint16
                                4;  % int32
                                4;  % uint32
                                8;  % int64
                                8]; % uint64
			
			byteData = byteData(:);

			dataClassEnum = byteData(curOffset);
			curOffset = curOffset + 1;
			dataNumDims   = byteData(curOffset);
			curOffset = curOffset + 1;

			dataSize      = zeros(1,dataNumDims,'uint32');

			for i = 1:dataNumDims
				dataSize(i) = typecast(byteData(curOffset:curOffset+3),'uint32');
				curOffset = curOffset+4;
			end

			if dataClassEnum == 0
				%custom object
				%header = [type  ndims  dim1  dim2    ...   classNameLen  className    | datasize DATA(1)  | ... |
				%          0     uint8 uint32 uint32 uint32   uint8         uint8[]    | uint32    uint8[] | ... |

				classNameLen = double(byteData(curOffset));
				curOffset = curOffset + 1;

				className = char(byteData(curOffset:curOffset+classNameLen-1));
				curOffset = curOffset+classNameLen;

				%compute number of elements
				numEls = prod(double(dataSize));
				for i = 1:numEls
					%grab the size for this object
					objSize = double(typecast(byteData(curOffset:curOffset+3),'uint32'));
					curOffset = curOffset + 4;

					%call the objects constructor w/ the byte array and 'ByteData' string
					data(i) = feval(className,byteData(curOffset:curOffset+objSize-1),'PackedBytes');
					curOffset = curOffset + objSize;
				end
				data = reshape(data,dataSize);

			elseif dataClassEnum == 13
				%struct

				%----Grab number of fields-----------------------------------------
				numFields = typecast(byteData(curOffset:curOffset+3),'uint32');
				curOffset = curOffset+4;
				%------------------------------------------------------------------

				%compute number of elements
				numEls = prod(double(dataSize));

				%-------Grab the fieldnames----------------------------------------
				fieldname = cell(1,numFields);
				for fieldcnt = 1:numFields
					fieldlen = double(byteData(curOffset));
					curOffset = curOffset + 1;

					fieldname{fieldcnt} = char(byteData(curOffset:curOffset+fieldlen-1))';
					curOffset = curOffset + fieldlen;
				end
				%------------------------------------------------------------------


				%-----------create data struct-array------------------------------
				tmpcell = cell(1,2*length(fieldname));
				tmpcell(1:2:end) = fieldname;
				tmpcell(2:2:end) = repmat({cell(1,numEls)},1,length(fieldname));
				data = struct(tmpcell{:});
				%------------------------------------------------------------------

				%------------slurp the data----------------------------------------
				for elcnt = 1:numEls
					for fieldcnt = 1:numFields
						[data(elcnt).(fieldname{fieldcnt}) curOffset] = CompressLib.unpackBytesRecurse(byteData,curOffset);
					end
				end
				data = reshape(data,dataSize);
				%------------------------------------------------------------------
			elseif dataClassEnum == 14
				%cell

				%compute number of elements
				numEls = prod(double(dataSize));

				data = cell(numEls,1);
				for i = 1:numEls
					[data{i} curOffset] = CompressLib.unpackBytesRecurse(byteData,curOffset);
				end
				data = reshape(data,dataSize);
			else
				%numeric/logical/char

				readLength = prod(double(dataSize))*getSizeFromClassEnum(dataClassEnum);
				switch dataClassEnum
					case 3
						%logical
						data = reshape(logical(byteData(curOffset:curOffset+readLength-1)),dataSize);
					case 4
						%char
						data = reshape(char(byteData(curOffset:curOffset+readLength-1)),dataSize);
					otherwise
						data = reshape(typecast(byteData(curOffset:curOffset+readLength-1),classEnumVal2Str{dataClassEnum}),dataSize);
				end
				curOffset = curOffset + double(readLength);
			end
		end
	end
end