clc;
close all;
angle = -30;
transHomo = [1 , 0, 0
              0, 0.5, 0
              0          , 0           , 1];
% Read a input image
imgRaw = imread('../(Sample Images)\fig1.jpg');
imgRawCopy = imgRaw;

% Make transformation matrix
transHomoT = transpose(transHomo);
transMat = projective2d(transHomoT);

% Perform image wapring 
imgOutput = imwarp(imgRawCopy, transMat);

% Display for testing only
figure;
subplot(1,3,1);
imshow(imgRaw); 
subplot(1,3,2);
imshow(imgOutput);
