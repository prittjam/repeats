clear variables;
clear globals
close all
clc


x = rand(3,


pos = randn(5,3);
ori = [rand()*2*pi, rand()*2*pi, rand()*pi];
eul = [0, pi, 0];

pos_prime_rot = pos*eul2rotm(ori, 'ZYX')*eul2rotm(eul, 'ZYX');
pos_prime = pos*eul2rotm(ori, 'ZYX');

hold on
plot3(pos_prime_rot(:,1), pos_prime_rot(:,2), pos_prime_rot(:,3), 'r')
scatter3(pos_prime_rot(:,1), pos_prime_rot(:,2), pos_prime_rot(:,3), 'ro')

plot3(pos_prime(:,1), pos_prime(:,2), pos_prime(:,3), 'b')
scatter3(pos_prime(:,1), pos_prime(:,2), pos_prime(:,3), 'bo')

camlight(-20, 70);
material('dull');
axis('equal');
view([-135 35]);
rotate3d on