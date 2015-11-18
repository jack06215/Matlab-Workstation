clc;
close all;
transHomo = [0.5, 0, 0
              0, 0.5, 0
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
imgOutput = imwarp(imgGray, transMat);

% Display for testing only
imshow(imgGray); figure; imshow(imgOutput);
