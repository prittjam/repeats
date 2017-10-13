function out = change_format(affpts)
out = affpts;
if isfield(affpts,'transformation')
	out = [];
	for i = 1:numel(affpts)
		out(i).class = affpts(i).lafType;
		out(i).id = affpts(i).drID;
		out(i).x = affpts(i).transformation(3,1);
		out(i).y = affpts(i).transformation(3,2);
		out(i).a11 = affpts(i).transformation(1,1);
		out(i).a12 = affpts(i).transformation(2,1);
		out(i).a21 = affpts(i).transformation(1,2);
		out(i).a22 = affpts(i).transformation(2,2);
	end
	out = out';
end
