%
%  Copyright (c) 2018 James Pritts
%  Licensed under the MIT License (see LICENSE for details)
%
%  Written by James Pritts
%
function model_list = eg_fix_oriented(u,sample,weights,degen_model_list,is_model_degen,cfg)
model_list = {};
for k = 1:numel(is_model_degen)
    if ~is_model_degen(k)
        model_list = cat(2,model_list,degen_model_list{k});
    end
end