classdef extrema < DR.gen
    properties
        subids;
    end

    methods
        function this = extrema()
            this.subids = ...
                containers.Map({class(MSER.CFG.mserp()),class(MSER.CFG.mserm())},[1 2]);
        end

        function res = make(this,img,feat_cfg_list,varargin)
            disp(['MSER detection ' img.url ':']);
                        
            a = img.data;

            cfg_list_names = cellfun(@(x) class(x),feat_cfg_list,'UniformOutput',false);
            subids = cell2mat(values(this.subids,cfg_list_names))';
            key_list = cellfun(@(x) DR.make_key(x),feat_cfg_list,'UniformOutput',false);
            if (numel(unique(key_list)) == 1)
                [mser img det_time] = extrema(a, ...
                                              DR.make_struct(feat_cfg_list{1}), ...
                                              subids);
            else
                mser = cell(1,numel(subids));
                det_time = zeros(1,numel(subids));
                for k = 1:numel(subids)
                    [mser(k) img] = extrema(a, ...
                                            DR.make_struct(feat_cfg_list{k}), ...
                                            subids(k));
                end
            end

            % store msers and images in apropriate cells
            res = cell(1,numel(subids));
            for k = 1:numel(subids)
                ind = 1:numel(mser{k});
                if ~isempty(mser{:,k})
                    res{k}.rle = mser{:,k};
                end
                %                res{k}.time = det_time(k);
            end
        end
    end
end