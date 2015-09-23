classdef Extrema < Gen
    properties(Constant)
        subids = containers.Map({class(MSER.CFG.Mserp()),class(MSER.CFG.Mserm())},[1 2]);
    end

    methods
        function this = Extrema()
        end
    end
    
    methods(Static)
        function res = make(img,feat_cfg_list,varargin)
            disp(['MSER detection ' img.url ':']);
            
            a = img.data;

            cfg_list_names = cellfun(@(x) class(x),feat_cfg_list,'UniformOutput',false);
            subids = cell2mat(values(MSER.Extrema.subids,cfg_list_names));
            key_list = cellfun(@(x) KEY.cfg2hash(x),feat_cfg_list,'UniformOutput',false);
            if (numel(unique(key_list)) == 1)
                [mser img det_time] = extrema(a, ...
                                              KEY.class_to_struct(feat_cfg_list{1}), ...
                                              subids);
                reflected = cell(size(mser));
                for k = 1:numel(reflected)
                    reflected{k} = zeros(1,size(mser{k},2));
                end
                if feat_cfg_list{1}.reflection
                    [mser0 img det_time] = extrema(IMG.reflect(a), ...
                                              KEY.class_to_struct(feat_cfg_list{1}), ...
                                              subids);
                    for k = 1:numel(reflected)
                        mser{k} = [mser{k} mser0{k}];
                        reflected{k} = [reflected{k} ones(1,size(mser0{k},2))];
                    end
                end
            else
                mser = cell(1,numel(subids));
                det_time = zeros(1,numel(subids));
                for k = 1:numel(subids)
                    [mser(k) img] = extrema(a, ...
                                            KEY.class_to_struct(feat_cfg_list{k}), ...
                                            subids(k));
                    reflected{k} = zeros(1,size(mser{k},2));
                    if feat_cfg_list{1}.reflection
                        [mser0(k) img] = extrema(IMG.reflect(a), ...
                                                KEY.class_to_struct(feat_cfg_list{k}), ...
                                                subids(k));
                        mser{k} = [mser{k} mser0{k}];
                        reflected{k} = [reflected{k} ones(1,size(mser0{k},2))];
                    end
                end
            end

            % store msers and images in apropriate cells
            res = cell(1,numel(subids));
            for k = 1:numel(subids)
                ind = 1:numel(mser{k});
                if ~isempty(mser{:,k})
                    res{k}.rle = mser{:,k};
                    res{k}.reflected = reflected{k};
                end
                %                res{k}.time = det_time(k);
            end
        end
    end
end