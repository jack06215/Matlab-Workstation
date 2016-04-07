%% Program Initialisation
addpath(genpath('.'));
% ccc;
close all; clc;
%% Waiting for user input
im = imread('DSC_0760.JPG');
%% Pre-defined parameters from previous program
% Image center
center = [size(im,2)/2; size(im,1)/2];
%% Construct homography matrix
K = [4.771474878444084e+02,0,0;0,4.771474878444084e+02,0;0,0,1];
X = [0.144290146310480,0.161245008361210,-0.502297992743877;-0.780126182696621,0.722906252917495,1.068252984437994;0.127068370467084,-0.144993347333665,0.094242399794410];
H_form = computeFrontalH(X(:,2), center, K, im);
H = H_form.T;
%% Warping
im_warp = imwarp(im, H_form);
% im_warp = my_imwarp(im, H');
%% Look-up table for original-prespective pixel mapping
% Find the size of img
sz = size(im);
% Original pixel index lookup table
[rows,cols]= meshgrid(1:sz(1), 1:sz(2));
A = [reshape(cols,1,[]);
     reshape(rows,1,[]);
     ones(1,length(rows(:)))]; 
% Perform warping 
AA = H' * A;
AA = AA ./ [AA(3,:); AA(3,:); AA(3,:)];
AA = int32(AA); % Truncate from float to int
% Offset the pixel location
ptYp = AA(2,:) - min(AA(2,:)) + 1;
ptXp = AA(1,:) - min(AA(1,:)) + 1;
ptXYp = [ptXp; ptYp];
ptXY = A([1,2],:);
%% Get 4 points from user
figure, imshow(im_warp);
hold on;
[ptXp, ptYp] = getpts;    % Get points from user select
lsX = floor(ptXp);lsY = floor(ptYp);
lsX = lsX + double(repmat(min(AA(1,:)) - 1,size(lsX,1),1)); 
lsY = lsY + double(repmat(min(AA(2,:)) - 1,size(lsY,1),1));
hold off;
close;
ls1p = [lsX(1); lsY(1); lsX(2); lsY(2)];
ls2p = [lsX(3); lsY(3); lsX(4); lsY(4)];
lv1p = twopts2L(ls1p);
lv2p = twopts2L(ls2p);
pts=[[ls1p(1:2),ls1p(3:4),ls2p(1:2),ls2p(3:4)];[1,1,1,1]];
ptsp=inv(H)'*pts; 
ptsp=ptsp(1:2,:)./[ptsp(3,:);ptsp(3,:)];
ls1p_back=[ptsp(:,1);ptsp(:,2)];ls1p_back = floor(ls1p_back);
ls2p_back=[ptsp(:,3);ptsp(:,4)];ls2p_back = floor(ls2p_back);
%% Show mapping result...
% Perspective view
figure, imshow(im_warp);
hold on;
plot(ptXp(1), ptYp(1), 'x', 'Color', 'red', 'LineWidth', 3);
plot(ptXp(2), ptYp(2), 'x', 'Color', 'cyan', 'LineWidth', 3);
plot(ptXp(3), ptYp(3), 'x', 'Color', 'yellow', 'LineWidth', 3);
plot(ptXp(4), ptYp(4), 'x', 'Color', 'magenta', 'LineWidth', 3);
hold off;
% Back-project to its original view
figure, imshow(im);
hold on;
plot(ls1p_back(1), ls1p_back(2), 'x', 'Color', 'red', 'LineWidth', 3);
plot(ls1p_back(3), ls1p_back(4), 'x', 'Color', 'cyan', 'LineWidth', 3);
plot(ls2p_back(1), ls2p_back(2), 'x', 'Color', 'yellow', 'LineWidth', 3);
plot(ls2p_back(3), ls2p_back(4), 'x', 'Color', 'magenta', 'LineWidth', 3);
hold off;
