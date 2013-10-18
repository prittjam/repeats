function [dr_defs,DRid] = dr_define(dr_defs,DRName, DetectorName, SubDetectorID, NativeVisualiser, DRRepresentation, DRUpgrades)
% DRName, DetectorName, SubDRId, DRVisualiser, DRrepresentation, DRRefinements

if nargin<7
  Overwrite=1;
end;

Names = dr_get_names(dr_defs);
DRid = find(strcmp(Names, DRName));

if (~isempty(DRid))
  % region already defined
  error('Region with that name already exists.');
else
  try 
    DRid = length(dr_defs)+1;
  catch
    DRid = 1;
  end;
end;

% basic DR characteristics
region.name = DRName;
region.generator = DetectorName;
region.subgenid = SubDetectorID;
region.visualiser = NativeVisualiser;

% output type characteristics
region.representation = DRRepresentation;
region.upgrades = DRUpgrades;

dr_defs = cat(2,dr_defs,region);
