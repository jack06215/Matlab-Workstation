clc;
close all;
transHomo = [1, 0, 0
              0, 1, 0
              0, 0, 1];
% Read a input image
imgRaw = imread('Sample Images\fig1.jpg');
imgGray = rgb2gray(imgRaw);

% Crop a ROI to become a template image
[imgTemplt, rectROI] = imcrop(imgGray);

% Make transformation matrix
transHomoT = transpose(transHomo);
transMat = projective2d(transHomoT);

% Perform image wapring 
[imgOutput, RimgOutput] = imwarp(imgGray, transMat);

% Display for testing only
imshow(imgGray, RimgGray); figure; imshow(imgOutput, RimgOutput);
