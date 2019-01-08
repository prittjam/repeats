function [] = test_output()
img_name = 'new_medium_63_o'
load(['output/' img_name '.mat']);
output_all_planes(meas.x,img,model_list);