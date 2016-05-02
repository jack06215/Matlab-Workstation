close all;
addpath(genpath('.'));
img = imread('Garfield_Building_Detroit.jpg');
img_gray = rgb2gray(img);
color = {'Red', 'Cyan', 'Yellow'};
%% Perform line segment detection and clustering based on Vanishing point
[ls,ls_label] = vp_lineCluster(img_gray);
% Conversion issue
ls = ls(:,1:4)';
ls = [ls(1,:); ls(3,:); ls(2,:); ls(4,:)];
%% Extract only vertical line segment
[ar,~] = find(ls_label == 2 | ls_label == 3);
ls_label(ar) = [];
ls(:,ar) = [];
%% Show result
figure, imshow(img)
hold on;
for i=1:size(ls,2)
    plot(ls([1,3],i), ls([2,4],i), 'Color', color{ls_label(i)}, 'LineWidth', 1);
end