function draw_results(img,res)
T0 = CAM.make_rd_div_tform(res.cc,res.q);
rimg = IMG.rectify(img.data,res.Hinf, ...
                   'Transforms', { T0 },'Scale','Yes');
uimg = IMG.ru_div(img.data,res.cc,res.q, ...
                  'Fill', [255 255 255]');
figure;
imshow(img.data);

figure;
subplot(1,2,1);
imshow(rimg);
subplot(1,2,2);
imshow(uimg);
