close all;
addpath(genpath('.'));
img = imread('f34235.jpg');
center = [size(img,2)/2; size(img,1)/2];
img_gray = rgb2gray(img);
color = {'Red', 'Cyan', 'Yellow'};
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
%% Perform line segment detection and clustering based on Vanishing point
[ls,ls_label] = vp_lineCluster(img_gray);
% Conversion issue
ls = ls(:,1:4)';
ls = [ls(1,:); ls(3,:); ls(2,:); ls(4,:)];
ls_center = ls - repmat(center, 2, size(ls, 2));
%% Tilt rectification experiment code
% Dummy data for experiment
AA(:,1) = [55;171;48.99;251];
AA(:,1) = [50;171;49.99;251];
AA(:,2) = [50;171;50;251];
AA_center = AA - repmat(center, 2, size(AA, 2));
% AA(:,1) = [100;171;95.99;251];
% AA(:,2) = [100;171;100;251];
% AA = [51.8856816655302;171.396646740405;48.5045622369089;251.481402040083];

% % Convert two points to stright line equation into format of ax + by + c = 0
% % Lout = twopts2L(ls_center);
% Lout_A = [ls_center(1:2,:); ones(1,size(ls,2))];
% Lout_B = [ls_center(3:4,:); ones(1,size(ls,2))];
% % Construct homography matrix that rotate about x-axis and y-axis
% R1 = makehgtform('xrotate',0,'yrotate',0); R1 = R1(1:3,1:3);
% Hinv = K * R1' * inv(K);
% % Applied homography to all line segment(stright line equation)
% Lp_A = Hinv'*Lout_A; 
% Lp_A = Lp_A./[Lp_A(3,:);Lp_A(3,:);Lp_A(3,:)];
% Lp_B = Hinv'*Lout_B;
% Lp_B = Lp_B./[Lp_B(3,:);Lp_B(3,:);Lp_B(3,:)];
% Vp = (Lp_A - Lp_B).^2;
% c = sum(Vp(2,:));
% Vp = Lp(2,:);
% C = (Vp).^2;
% c = sum(C);
%% Extract only vertical line segment
[ar,~] = find(ls_label == 2 | ls_label == 3);
ls_label(ar) = [];
ls(:,ar) = [];
% Lout(:,ar) = [];
[H,x,fval] = rectifyInplaneR(ls_center,K);
%% Show result
figure,imshow(img);
% xmin = 0;
% xmax = 640;
% ymin = 0;
% ymax = 360;
% axis([xmin, xmax, ymin, ymax]);
hold on;
for i=1:size(ls,2)
    plot(ls([1,3],i), ls([2,4],i), 'Color', color{ls_label(i)}, 'LineWidth', 1);
end
