classdef syscfg
    properties 
        map
    end

    methods
        function this = syscfg()
            if (exist('extrema') == 3)
                this.map = containers.Map({'MSER.CFG.mserp','MSER.CFG.mserm','AFFPTS.CFG.hessian_affine', ... 
                 'MSER.CFG.mserp:LAF.CFG.laf', 'MSER.CFG.mserm:LAF.CFG.laf', 'LAF.CFG.laf:SIFT.CFG.sift', ...
                        'AFFPTS.CFG.hessian_affine:SIFT.CFG.sift'}, ...
                 {'make_extrema','make_extrema','make_hessian_affine', ...
                    'make_mser_to_laf','make_mser_to_laf','make_affpt_to_sift','make_affpt_to_sift' });
            else
                throw(MException('','Cannot find feature mex'));
            end
        end

        function chain = go_chain(this,cfg_list)
            gen_str = cell(1,numel(cfg_list));
            for i = 1:numel(cfg_list)
                gen_str{i} = cell(1,numel(cfg_list{i}));
                name = '';
                for j = 1:numel(gen_str{i})
                    gen_str{i}{j} = values(this.map, {[name class(cfg_list{i}{j})]});
                    name = [class(cfg_list{i}{j}) ':'];
                end
            end
            chain = cellfun(@(x) cellfun(@(y) feval(str2func(y{:})),x, ...
                'UniformOutput',false),gen_str,'UniformOutput',false);
        end
        
    end
end

function extrema = make_extrema()
    extrema = MSER.extrema();
end

function extrema = make_hessian_affine()
    extrema = AFFPTS.affpts();
end

function mser_to_laf = make_mser_to_laf()
    mser_to_laf = MSER.mser_to_laf();
end

function affpt_to_sift = make_affpt_to_sift()
    affpt_to_sift = AFFPTS.affpt_to_sift();
end
