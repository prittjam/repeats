%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function [model_list,lo_res_list,stats_list] = rectify_planes(x,G,solver,K,varargin)
    [model_list,lo_res_list,stats_list] = ...
        fit_coplanar_patterns(solver,x,G,K,1,varargin{:});