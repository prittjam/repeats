function [] = draw3d_affine_csystem(ax1,A,o,varargin)
p = inputParser;
p.KeepUnmatched = true;
p.addParamValue('color','k',@ischar);
p.addParamValue('axislabel',[],@isstr);
p.addParamValue('scale',1,@isfloat);
p.parse(varargin{:});

color = p.Results.color;
label = p.Results.axislabel;
s = p.Results.scale;

axes(ax1);
m = size(A,2);
u = [1 1 4; 1 1 4; 1 1 4].*A+repmat(o,1,m);

hold on;
line([repmat(o(1),1,m);u(1,:)], ...
     [repmat(o(2),1,m);u(2,:)], ...
     [repmat(o(3),1,m);u(3,:)], ...
     'Color', color);
labels = ['xyzw'];

if ~isempty(label)
    v = 1.1*s*A+repmat(o,1,m);
    for j = 1:m
        text(v(1,j),v(2,j),v(3,j), ...
             [label '_' labels(j)], ...
             'color', color);
    end
end

hold off;