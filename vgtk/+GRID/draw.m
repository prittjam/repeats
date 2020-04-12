function draw(xgrid, varargin)
    xgrid = PT.renormI(xgrid);
    hold on
    scatter(xgrid(1,:), xgrid(2,:), 'filled', varargin{:});
end