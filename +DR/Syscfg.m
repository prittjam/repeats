classdef Syscfg
    properties 
        map
    end

    methods
        function this = Syscfg()
            if (exist('extrema') == 3)
                this.map = containers.Map({'MSER.CFG.Mserp','MSER.CFG.Mserm','AFFPTS.CFG.HessianAffine', ... 
                                    'LAF.CFG.Laf', 'SIFT.CFG.Sift', ...
                                    'LAF.CFG.Distinct'}, ...
                                          {'make_extrema','make_extrema','make_hessian_affine', ...
                                    'make_mser_to_laf','make_affpt_to_sift', ... 
                                    'make_distinct' });
            else
                throw(MException('','Cannot find feature mex'));
            end
        end

        function chain = cfgs_to_gens(this,cfg_list)
            gen_str = cell(1,numel(cfg_list));
            for i = 1:numel(cfg_list)
                gen_str{i} = cell(1,numel(cfg_list{i}));
                for j = 1:numel(gen_str{i})
                    gen_str{i}{j} = values(this.map, {class(cfg_list{i}{j})});
                end
            end
            chain = cellfun(@(x) cellfun(@(y) feval(str2func(y{:})),x, ...
                'UniformOutput',false),gen_str,'UniformOutput',false);
        end
        
    end
end

function extrema = make_extrema()
    extrema = MSER.Extrema();
end

function extrema = make_hessian_affine()
    extrema = AFFPTS.Affpts();
end

function mser_to_laf = make_mser_to_laf()
    mser_to_laf = LAF.MserToLaf();
end

function affpt_to_sift = make_affpt_to_sift()
    affpt_to_sift = SIFT.AffptToSift();
end

function dist = make_distinct()
    dist = LAF.LafToDistinctLaf();
end
