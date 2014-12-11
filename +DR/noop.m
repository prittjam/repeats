classdef noop < DR.gen
    methods
        function this = noop()
        end

        function res = upgrade_features(this,img,prev_list,upg_cfg_list)
            res = prev_list;
        end
    end
end