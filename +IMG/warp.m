function [timg,trect,T,A] = warp(img, H, varargin)
     assert(all(size(H) == [3 3]));

     [ny,nx,~] = size(img);
     cfg.border = [1  1; ...
                  nx 1; ...    
                  nx ny; ...
                  1  ny];
     cfg.size = size(img);
     cfg.rd_xform = maketform('affine',eye(3));
     cfg.fill = [255 255 255]';
     cfg.scale_output = 1;
     
     [cfg,leftover] = cmp_argparse(cfg,varargin{:});
     
     leftover = { 'Fill', cfg.fill, ...
                  leftover{:} };

     if isempty(cfg.rd_xform)
          T = maketform('projective',H');
     else
          T = maketform('composite', ...
                        cfg.rd_xform, ...
                        maketform('projective',H'));
     end

     A = eye(3);
 
 
     [T,A2] = IMG.register_by_size(T,cfg.border,cfg.size, ...
                                   'LockAspectRatio','true');
     A = A2*A;
     
     outbounds = tformfwd(T,cfg.border);
 
     timg = imtransform(img,T,'bicubic', ...
                        'XData', [min(outbounds(:,1)) max(outbounds(:,1))], ...
                        'YData', [min(outbounds(:,2)) max(outbounds(:,2))], ...
                        'XYScale',1/cfg.scale_output, ...
                        leftover{:}); 
     
     trect = [min(outbounds(:,1)) min(outbounds(:,2)) ...
              max(outbounds(:,1)) max(outbounds(:,2))];
                                                      
end