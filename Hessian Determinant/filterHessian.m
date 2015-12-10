% Cleaning up the screen and previous variables
clear; 
close all;

% Read in an image
imageIn = imread('Sample Images\fig1.jpg');
imgRef = imref2d(size(imageIn));
imageInGray = rgb2gray(imageIn);

[gx, gy] = gradient(double(imageInGray));
[gxx, gxy] = gradient(gx);
[gxy, gyy] = gradient(gy);

gauKernal = fspecial('gaussian', 11, 0.5);

gxx = imfilter(gxx, gauKernal, 'replicate');
gxy = imfilter(gxy, gauKernal, 'replicate');
gyy = imfilter(gyy, gauKernal, 'replicate');

detH = (gxx .* gyy) - (gxy .* gxy);

% Display the reuslt
fig1 = subplot(1,2,1);
imshow(imageIn, 'InitialMagnification', 'fit');
title(fig1, 'Original');

fig2 = subplot(1,2,2);
imshow(detH, 'InitialMagnification', 'fit');
title(fig2, 'detH');

