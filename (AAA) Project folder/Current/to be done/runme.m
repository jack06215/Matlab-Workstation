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
%% Delete vertical line segment
[ar,~] = find(ls_label==2);
ls_label(ar) = [];
ls(:,ar) = [];
%% Midpoint of line segment
ls_midpt = zeros(2,size(ls,2));
for i=1:size(ls,2)
    ls_midpt(1,i) = (ls(1,i) + ls(3,i)) / 2;
    ls_midpt(2,i) = (ls(2,i) + ls(4,i)) / 2;
end
%% Build adjacency matrix
LS_L = twopts2L(ls);
LS_Adj = ones(size(ls,2));
LS_Adj(logical(eye(size(LS_Adj)))) = 0;
LS_Adj = triu(LS_Adj);
[ar,ac] = find(LS_Adj>0);

intpt = zeros(3,size(ar,1));
for i=1:size(intpt,2)
    intpt(:,i) = az_hcross(LS_L(:,ar(i)),LS_L(:,ac(i)));
end
intpt = intpt(1:2,:);
%% Show result
figure, imshow(img)
hold on;
% xmin = -2000;
% xmax = 2000;
% ymin = -2000;
% ymax = 2000;
% axis([xmin, xmax, ymin, ymax]);

for i=1:size(ls,2)
    plot(ls([1,3],i), ls([2,4],i), 'Color', color{ls_label(i)}, 'LineWidth', 1);
end
% plot(intpt(1,:),intpt(2,:), 'x', 'Color', 'Black', 'LineWidth', 1);
plot(ls_midpt(1,:),ls_midpt(2,:), 'x', 'Color', 'Black', 'LineWidth', 1);