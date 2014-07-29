classdef extrema < matlab.mixin.Heterogeneous
    properties
        subids;
    end

    methods
        function this = extrema()
            this.subids = containers.Map({class(dr.mserp_cfg()),class(dr.mserm_cfg())},[1 2]);
        end

        function res = extract_features(this,img,feat_cfg_list)
            msg(1,'MSER detection (%s):\n', img.url);
                        
            a = img.data;
            
            if (check_flag('CFG.extrema.presmooth')>0)
                sigma = CFG.extrema.presmooth;
                g = fspecial('gaussian', 6*sigma, sigma);
                a(:,:,1) = conv2(a(:,:,1), g,'same');
                a(:,:,2) = conv2(a(:,:,2), g,'same');
                a(:,:,3) = conv2(a(:,:,3), g,'same');
            end;

            cfg_list_names = arrayfun(@(x) class(x),feat_cfg_list,'UniformOutput',false);
            subids = cell2mat(values(this.subids,cfg_list_names));
            key_list = arrayfun(@(x) dr.make_key(x),feat_cfg_list,'UniformOutput',false);
            if (numel(unique(key_list)) == 1)
                [mser img det_time] = extrema(a, ...
                                              dr.make_struct(feat_cfg_list(1)), ...
                                              subids);
            else
                mser = cell(1,numel(subids));
                det_time = zeros(1,numel(subids));
                for k = 1:numel(subids)
                    [mser(k) img det_time(k)] = extrema(a, ...
                                                        dr.make_struct(feat_cfg_list(k)), ...
                                                        subids(k));
                end
            end

            % store msers and images in apropriate cells
            for k = 1:numel(subids)
                ind = 1:numel(mser{k});
                %    res{k}.rle = dr_rm_overlapping_msers(dr(k),mser{k});   
                res{k}.rle = mser{:,k};
                res{k}.time = det_time(k);
            end
        end
    end
end