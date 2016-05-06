ccc;
addpath(genpath('.'));
img = imread('data/buildin33.jpg');
img_gray = rgb2gray(img);
center = [size(img,2)/2; size(img,1)/2];
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];

%% Algorithm starts from here
% Line segment detection and clustering based on vanishing point
[ls,ls_center,ls_label] = vp_lineCluster(img_gray,center);

% Keep only vertical line segment
[ar,~] = find(ls_label==2 | ls_label==3);
ls_label(ar) = [];
ls_center(:,ar) = [];
ls(:,ar) = [];

% Camera tilt rectification using Levenberg-Marquardt optimisation method
x = tiltRectification(ls_center,K);

% Obtain the result warping image
imgp = getPerspectiveImg(img,x,K);

% Show result
figure;
imshow(img), hold on;
color = {'Red', 'Cyan', 'Yellow'};
for i=1:size(ls,2)
    plot(ls([1,3],i), ls([2,4],i), 'Color', color{ls_label(i)}, 'LineWidth', 1);
%     pause(1);
%     disp(num2str(i));
end
figure, imshow(imgp);