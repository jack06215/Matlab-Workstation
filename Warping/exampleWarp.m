% Cleaning up the screen and previous variables
clear; 
close all;

% Read in an image
img = imread('Sample Images\fig1.jpg');
imgRef = imref2d(size(img));

% This is the homography matrix
m =[cosd(45), sind(45), 0;
    sind(-45), cosd(45), 0;
    0, 0, 1];
tic;
affineMat = affine2d(m);
imgNew = imwarp(img, affineMat);
toc;
imgNewRef = imref2d(size(imgNew));
% Display the reuslt
figure('position',[200,500,500,300]);
imshow(img, imgRef);
figure('position',[800,500,500,300]);
imshow(imgNew, imgNewRef);